//
//  Lazy.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

internal enum LazyState<A> {
	case Eventually(() -> A)
	case Now(Box<A>)
}

/// @autoclosure as a monad.
public struct Lazy<A> {
	let state : STRef<(), LazyState<A>>
	
	init(_ state : STRef<(), LazyState<A>>) {
		self.state = state
	}
}

public func delay<A>(f : () -> A) -> Lazy<A> {
	return Lazy(newSTRef(.Eventually(f)).runST())
}

public func force<A>(l : Lazy<A>) -> A {
	return (modifySTRef(l.state)({ st in
		switch st {
			case .Eventually(let f):
				return .Now(Box(f()))
			default:
				return st
		}
	}) >>- { st in
		switch readSTRef(st).runST() {
			case .Now(let bx):
				return ST<(), A>.pure(bx.unBox())
			default:
				assert(false)
		}
	}).runST()
}

extension Lazy : Functor {
	typealias B = Any
	typealias FA = Lazy<A>
	typealias FB = Lazy<B>
	
	public static func fmap<B>(f: A -> B) -> Lazy<A> -> Lazy<B> {
		return { st in
			switch readSTRef(st.state).runST() {
				case .Eventually(let d):
					return delay({ f(d()) })
				case .Now(let bx):
					return self.pure(f(bx.unBox()))
			}
		}
	}
}

public func <%><A, B>(f: A -> B, st: Lazy<A>) -> Lazy<B> {
	return Lazy.fmap(f)(st)
}

public func <%<A, B>(x : A, l : Lazy<B>) -> Lazy<A> {
	return Lazy.fmap(const(x))(l)
}

extension Lazy : Applicative {
	typealias FAB = Lazy<A -> B>
	
	public static func pure<A>(a: A) -> Lazy<A> {
		return Lazy<A>(newSTRef(.Now(Box(a))).runST())
	}
}

public func <*><A, B>(stfn: Lazy<A -> B>, st: Lazy<A>) -> Lazy<B> {
	switch readSTRef(stfn.state).runST() {
		case .Eventually(let d):
			return delay({ d()(force(st)) })
		case .Now(let bx):
			return Lazy.fmap(bx.unBox())(st)
	}
}

public func *><A, B>(a : Lazy<A>, b : Lazy<B>) -> Lazy<B> {
	return const(id) <%> a <*> b
}

public func <*<A, B>(a : Lazy<A>, b : Lazy<B>) -> Lazy<A> {
	return const <%> a <*> b
}

extension Lazy : Monad {
	public func bind<B>(f: A -> Lazy<B>) -> Lazy<B> {
		return f(force(self))
	}
}

public func >>-<A, B>(x : Lazy<A>, f : A -> Lazy<B>) -> Lazy<B> {
	return x.bind(f)
}

public func >><A, B>(x : Lazy<A>, y : Lazy<B>) -> Lazy<B> {
	return x.bind({ (_) in
		return y
	})
}


public struct LazySequenceOf<S : SequenceType, A where S.Generator.Element == A> : SequenceType {
	let seq : S
	public init(_ seq : S) {
		self.seq = seq
	}
	
	public func generate() -> GeneratorOf<A> {
		return GeneratorOf(seq.generate())
	}
	
	public subscript(i : Int) -> A {
		var gen = self.generate()
		var res : A? = gen.next()
		for x in 0..<i {
			res = gen.next()

		}
		return res!
	}
}
