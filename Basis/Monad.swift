//
//  Monad.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

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

public func guard<M : MonadPlus where M.A == Void, M.FA == M>(b : Bool) -> M {
	return b ? M.pure(()) : M.mzero()
}

public func when<M : Monad where M.A == Void, M.FA == M>(b : Bool) -> M -> M {
	return { m in b ? m : M.pure(()) }
}

public func unless<M : Monad where M.A == Void, M.FA == M>(b : Bool) -> M -> M {
	return { m in b ? M.pure(()) : m }
}

