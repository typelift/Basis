//
//  ST.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

// The strict state-transformer monad.  ST<S, A> represents a computation returning a value of type 
// A using some internal context of type S.
public struct ST<S, ATV> {	
	fileprivate let apply : (World<RealWorld>) -> (World<RealWorld>, ATV)
	
	init(apply : @escaping (World<RealWorld>) -> (World<RealWorld>, ATV)) {
		self.apply = apply
	}
	
	// Returns the value after completing all transformations.
	public func runST() -> ATV {
		let (_, x) = self.apply(realWorld)
		return x
	}
}

extension ST : Functor {
	public typealias B = Any
	public typealias FB = ST<S, B>

	public static func fmap<B>(_ f: @escaping (A) -> B) -> (ST<S, A>) -> ST<S, B> {
		return { st in
			return ST<S, B>(apply: { s in
				let (nw, x) = st.apply(s)
				return (nw, f(x))
			})
		}
	}
}

public func <^> <S, A, B>(f: @escaping (A) -> B, st: ST<S, A>) -> ST<S, B> {
	return ST.fmap(f)(st)
}

public func <^ <S, A, B>(x : A, l : ST<S, B>) -> ST<S, A> {
	return ST.fmap(const(x))(l)
}

public func ^> <S, A, B>(l : ST<S, B>, x : A) -> ST<S, A> {
	return flip(<^)(l, x)
}

extension ST : Pointed {
  public typealias A = ATV
  
	public static func pure<S, A>(_ a: A) -> ST<S, A> {
		return ST<S, A>(apply: { s in
			return (s, a)
		})
	}
}

extension ST : Applicative {
	public typealias FAB = ST<S, (A) -> B>
	
	public static func ap<S, A, B>(_ stfn: ST<S, (A) -> B>) -> (ST<S, A>) -> ST<S, B> {
		return { st in ST<S, B>(apply: { s in
			let (nw, f) = stfn.apply(s)
			return (nw, f(st.runST()))
		}) }
	}
}

public func <*> <S, A, B>(stfn: ST<S, (A) -> B>, st: ST<S, A>) -> ST<S, B> {
	return ST<S, A>.ap(stfn)(st)
}

public func *> <S, A, B>(a : ST<S, A>, b : ST<S, B>) -> ST<S, B> {
	return const(id) <^> a <*> b
}

public func <* <S, A, B>(a : ST<S, A>, b : ST<S, B>) -> ST<S, A> {
	return const <^> a <*> b
}

extension ST : ApplicativeOps {
	public typealias C = Any
	public typealias FC = ST<S, C>
	public typealias D = Any
	public typealias FD = ST<S, D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (ST<S, A>) -> ST<S, B> {
		return { a in ST<S, (A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (ST<S, A>) -> (ST<S, B>) -> ST<S, C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (ST<S, A>) -> (ST<S, B>) -> (ST<S, C>) -> ST<S, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension ST : Monad {
	public func bind<B>(_ f : @escaping (A) -> ST<S, B>) -> ST<S, B> {
		return f(runST())
	}
}

public func >>- <S, A, B>(x : ST<S, A>, f : @escaping (A) -> ST<S, B>) -> ST<S, B> {
	return x.bind(f)
}

public func >> <S, A, B>(x : ST<S, A>, y : ST<S, B>) -> ST<S, B> {
	return x.bind({ (_) in
		return y
	})
}

extension ST : MonadOps {
	public typealias MLA = ST<S, [A]>
	public typealias MLB = ST<S, [B]>
	public typealias MU = ST<S, ()>
	
	public static func mapM<B>(_ f : @escaping (A) -> ST<S, B>) -> ([A]) -> ST<S, [B]> {
		return { xs in ST<S, B>.sequence(map(f)(xs)) }
	}
	
	public static func mapM_<B>(_ f : @escaping (A) -> ST<S, B>) -> ([A]) -> ST<S, ()> {
		return { xs in ST<S, B>.sequence_(map(f)(xs)) }
	}
	
	public static func forM<B>(_ xs : [A]) -> (@escaping (A) -> ST<S, B>) -> ST<S, [B]> {
		return flip(ST.mapM)(xs)
	}
	
	public static func forM_<B>(_ xs : [A]) -> (@escaping (A) -> ST<S, B>) -> ST<S, ()> {
		return flip(ST.mapM_)(xs)
	}
	
	public static func sequence(_ ls : [ST<S, A>]) -> ST<S, [A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in ST<S, [A]>.pure(cons(x)(xs)) } } })(ST<S, [A]>.pure([]))(ls)
	}
	
	public static func sequence_(_ ls : [ST<S, A>]) -> ST<S, ()> {
		return foldr(>>)(ST<S, ()>.pure(()))(ls)
	}
}

public func -<< <S, A, B>(f : @escaping (A) -> ST<S, B>, xs : ST<S, A>) -> ST<S, B> {
	return xs.bind(f)
}

public func >>->> <S, A, B, C>(f : @escaping (A) -> ST<S, B>, g : @escaping (B) -> ST<S, C>) -> (A) -> ST<S, C> {
	return { x in f(x) >>- g }
}

public func <<-<< <S, A, B, C>(g : @escaping (B) -> ST<S, C>, f : @escaping (A) -> ST<S, B>) -> (A) -> ST<S, C> {
	return { x in f(x) >>- g }
}

extension ST : MonadFix {
	public static func mfix(_ f : (A) -> ST<S, A>) -> ST<S, A> {
		return f(ST.mfix(f).runST())
	}
}

// Shifts an ST computation into the IO monad.  Only ST's indexed
// by the real world qualify to be converted.
internal func stToIO<A>(_ m: ST<RealWorld, A>) -> IO<A> {
	return IO<A>.pure(m.runST())
}
