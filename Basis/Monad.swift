//
//  Monad.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// A Monad is an (Endo)Functor (but really, that doesn't matter because all Functors in Swift are
/// *technically* endofunctors) that respects a common-sense set of laws called the Monoid Laws:
///
/// - Closure    Composing two monads produces another monad.  Actually, the same monad, but with a
///              different value inside.  Basically, you cannot ever just compose a monad and
///              randomly come up with something that isn't a monad.
///
/// - Associativity    Composing a monad twice is the same whether you bunch your parenthesis up on
///                    the right side, or the left side. (1 + 1) + 1 = 1 + (1 + 1)
///
/// - Identity    There is some element in the set of possible parametrizations that, when composed
///               with other elements, doesn't alter their value.  Like 0 in addition of the
///               integers: 0 + 1 = 1 + 0 = 1
///
/// A Monad lifts these laws into an algebraic structure and adds an all-important operator for 
/// "sequencing" monads together.
///
/// Monads represent a computation in a "context".  If we make that context the "real world" we get
/// the IO Monad.  When that context is the surrounding spine in a structure, we get the List Monad.
///
/// When a chain of monads is built up (M<M<M<...A...>>>), computation is performed by removing an
/// outer M<...>.
public protocol Monad : Applicative {	
	/// Bind is a function obtained by embedding a monad in a Kleisli Category.  It allows one to
	/// define a function that "shifts" the contents of the monad by some function, but still stay
	/// inside the monad.
	///
	/// Bind is famous because it allows one to build arbitrary pipes of computations with no effort
	/// at all.  You may have seen it notated >>-
	func bind(f : A -> FB) -> FB
}

/// A monoid for monads.
public protocol MonadPlus : Monad {
	class func mzero() -> FA
	class func mplus(FA) -> FA -> FA
}

public func >>-<MA : Monad, MB : Monad where MA.FB : Monad>(m : MA, f : MA.A -> MB) -> MB {
	return unsafeCoerce(m.bind(unsafeCoerce(f)))
}

public func >><MA : Monad, MB : Monad where MA.FB : Monad>(x : MA, y : MB) -> MB {
	return unsafeCoerce(x >>- { _ in unsafeCoerce(y) as MA.FB }) as MB
}

public func -<< <MA : Monad, MB : Monad where MA.FB == MB >(f : MA.A -> MB, m : MA)-> MB {
	return m.bind(f)
}

public func >=><MA : Monad, MB : Monad, MC : Monad where MA.FB == MB, MB.FB == MC>(f : MA.A -> MB, g : MB.A -> MC) -> MA.A -> MC {
	return { x in f(x) >>- g }
}

public func <=<<MA : Monad, MB : Monad, MC : Monad where MA.FB == MB, MB.FB == MC>(g : MB.A -> MC, f : MA.A -> MB) -> MA.A -> MC {
	return { x in f(x) >>- g }
}

public func liftM<MA : Monad>(f : MA.A -> MA.B) -> MA.FA -> MA.FB {
	return { m in MA.fmap(f)(m) }
}

public func liftM2<MA : Monad, MB : Monad, MC : Monad where MA.FB == MC, MB.FB == MC, MC.FA == MC>
	(f : MA.A -> MB.A -> MC.A) -> MA -> MB -> MC {
	return { (let m1 : MA) in { (let m2 : MB) in
		m1 >>- { x1 in m2 >>- { x2 in MC.pure(f(x1)(x2)) } }
	} }
}

public func liftM3<MA : Monad, MB : Monad, MC : Monad, MD : Monad where MA.FB == MD, MB.FB == MD, MC.FB == MD, MD.FA == MD>
	(f : MA.A -> MB.A -> MC.A -> MD.A) -> MA -> MB -> MC -> MD {
	return { (let m1 : MA) in { (let m2 : MB) in { (let m3 : MC) in
		m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in MD.pure(f(x1)(x2)(x3)) } } }
	} } }
}

public func liftM4<MA : Monad, MB : Monad, MC : Monad, MD : Monad, ME : Monad where MA.FB == ME, MB.FB == ME, MC.FB == ME, MD.FB == ME, ME.FA == ME>
	(f : MA.A -> MB.A -> MC.A -> MD.A -> ME.A) -> MA -> MB -> MC -> MD -> ME {
	return { (let m1 : MA) in { (let m2 : MB) in { (let m3 : MC) in { (let m4 : MD) in
		m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in m4 >>- { x4 in ME.pure(f(x1)(x2)(x3)(x4)) } } } }
	} } } }
}

public func liftM5<MA : Monad, MB : Monad, MC : Monad, MD : Monad, ME : Monad, MF : Monad where MA.FB == MF, MB.FB == MF, MC.FB == MF, MD.FB == MF, ME.FB == MF, MF.FA == MF>
	(f : MA.A -> MB.A -> MC.A -> MD.A -> ME.A -> MF.A) -> MA -> MB -> MC -> MD -> ME -> MF {
	return { (let m1 : MA) in { (let m2 : MB) in { (let m3 : MC)  in { (let m4 : MD)  in { (let m5 : ME) in
		m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in m4 >>- { x4 in m5 >>- { x5 in MF.pure(f(x1)(x2)(x3)(x4)(x5)) } } } } }
	} } } } }
}

public func join<MMA : Monad, MA : Monad where MMA.A == MA, MMA.FB == MA>(m : MMA) -> MA {
	return m >>- id
}

//public func sequence_<M : Monad where M.FB == M>(ms : [M]) -> M {
//	let f = foldr(>>)(M.pure(Void()))(ms)
//	return f
//}

public func guard<M : MonadPlus where M.A == Void, M.FA == M>(b : Bool) -> M {
	return b ? M.pure(()) : M.mzero()
}

public func when<M : Monad where M.A == Void, M.FA == M>(b : Bool) -> M -> M {
	return { m in b ? m : M.pure(()) }
}

public func unless<M : Monad where M.A == Void, M.FA == M>(b : Bool) -> M -> M {
	return { m in b ? M.pure(()) : m }
}

public func forever<M : Monad where M.FB == M>(a : M) -> M {
	return a >>- { _ in forever(a) }
}

