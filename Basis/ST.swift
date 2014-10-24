//
//  ST.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

// The strict state-transformer monad.  ST<S, A> represents
// a computation returning a value of type A using some internal
// context of type S.
public final class ST<S, A> : K2<S, A> {	
	private var apply:(s: World<RealWorld>) -> (World<RealWorld>, A)
	
	init(apply:(s: World<RealWorld>) -> (World<RealWorld>, A)) {
		self.apply = apply
	}
	
	// Returns the value after completing all transformations.
	public func runST() -> A {
		let (_, x) = self.apply(s: realWorld)
		return x
	}
}

extension ST : Functor {
	typealias B = Any
	typealias FA = ST<S, A>
	typealias FB = ST<S, B>

	public class func fmap<B>(f: A -> B) -> ST<S, A> -> ST<S, B> {
		return { st in
			return ST<S, B>(apply: { s in
				let (nw, x) = st.apply(s: s)
				return (nw, f(x))
			})
		}
	}
}

public func <%><S, A, B>(f: A -> B, st: ST<S, A>) -> ST<S, B> {
	return ST.fmap(f)(st)
}

public func <%<S, A, B>(x : A, l : ST<S, B>) -> ST<S, A> {
	return ST.fmap(const(x))(l)
}

extension ST : Applicative {
	typealias FAB = ST<S, A -> B>

	public class func pure<S, A>(a: A) -> ST<S, A> {
		return ST<S, A>(apply: { s in
			return (s, a)
		})
	}
}

public func <*><S, A, B>(stfn: ST<S, A -> B>, st: ST<S, A>) -> ST<S, B> {
	return ST<S, B>(apply: { s in
		let (nw, f) = stfn.apply(s: s)
		return (nw, f(st.runST()))
	})
}

public func *><S, A, B>(a : ST<S, A>, b : ST<S, B>) -> ST<S, B> {
	return const(id) <%> a <*> b
}

public func <*<S, A, B>(a : ST<S, A>, b : ST<S, B>) -> ST<S, A> {
	return const <%> a <*> b
}

extension ST : Monad {
	public func bind<B>(f: A -> ST<S, B>) -> ST<S, B> {
		return f(runST())
	}
}

public func >>-<S, A, B>(x : ST<S, A>, f : A -> ST<S, B>) -> ST<S, B> {
	return x.bind(f)
}

public func >><S, A, B>(x : ST<S, A>, y : ST<S, B>) -> ST<S, B> {
	return x.bind({ (_) in
		return y
	})
}

// Shifts an ST computation into the IO monad.  Only ST's indexed
// by the real world qualify to be converted.
internal func stToIO<A>(m: ST<RealWorld, A>) -> IO<A> {
	return IO<A>.pure(m.runST())
}
