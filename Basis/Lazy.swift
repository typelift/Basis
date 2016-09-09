//
//  Lazy.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

internal enum LazyState<A> {
	case eventually(() -> A)
	case now(A)
}

/// @autoclosure as a monad.
public struct Lazy<A> {
	let state : STRef<(), LazyState<A>>
	
	init(_ state : STRef<(), LazyState<A>>) {
		self.state = state
	}
}

public func delay<A>(_ f : @escaping () -> A) -> Lazy<A> {
	let ff = LazyState<A>.eventually(f)
	let rr : ST<(), STRef<(), LazyState<A>>> = newSTRef(ff)
	return Lazy<A>(rr.runST())
}

public func force<A>(_ l : Lazy<A>) -> A {
	return (modifySTRef(l.state)({ st in
		switch st {
			case .eventually(let f):
				return .now(f())
			default:
				return st
		}
	}).bind { st in
		switch readSTRef(st).runST() {
			case .now(let bx):
				return ST<(), A>.pure(bx)
			default:
				fatalError("Cannot ")
		}
	}).runST()
}

extension Lazy : Functor {
	public typealias B = Any
	public typealias FB = Lazy<B>
	
	public static func fmap<B>(_ f: @escaping (A) -> B) -> (Lazy<A>) -> Lazy<B> {
		return { st in
			switch readSTRef(st.state).runST() {
				case .eventually(let d):
					return delay({ f(d()) })
				case .now(let bx):
					return self.pure(f(bx))
			}
		}
	}
}

public func <^><A, B>(f: @escaping (A) -> B, st: Lazy<A>) -> Lazy<B> {
	return Lazy.fmap(f)(st)
}

public func <^<A, B>(x : A, l : Lazy<B>) -> Lazy<A> {
	return Lazy.fmap(const(x))(l)
}

public func ^> <A, B>(c : Lazy<B>, a : A) -> Lazy<A> {
	return flip(<^)(c, a)
}

extension Lazy : Pointed {
	public static func pure<A>(_ a: A) -> Lazy<A> {
		return Lazy<A>(newSTRef(.now(a)).runST())
	}
}

extension Lazy : Applicative {
	public typealias FAB = Lazy<(A) -> B>
	
	public static func ap<A, B>(_ stfn: Lazy<(A) -> B>) -> (Lazy<A>) -> Lazy<B> {
		return { st in
			switch readSTRef(stfn.state).runST() {
				case .eventually(let d):
					return delay({ d()(force(st)) })
				case .now(let bx):
					return Lazy<A>.fmap(bx)(st)
			}
		}
	}
}

public func <*><A, B>(stfn: Lazy<(A) -> B>, st: Lazy<A>) -> Lazy<B> {
	return Lazy<A>.ap(stfn)(st)
}

public func *><A, B>(a : Lazy<A>, b : Lazy<B>) -> Lazy<B> {
	return const(id) <^> a <*> b
}

public func <*<A, B>(a : Lazy<A>, b : Lazy<B>) -> Lazy<A> {
	return const <^> a <*> b
}

extension Lazy : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Lazy<C>
	public typealias D = Any
	public typealias FD = Lazy<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Lazy<A>) -> Lazy<B> {
		return { a in Lazy<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Lazy<A>) -> (Lazy<B>) -> Lazy<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Lazy<A>) -> (Lazy<B>) -> (Lazy<C>) -> Lazy<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Lazy : Monad {
	public func bind<B>(_ f: @escaping (A) -> Lazy<B>) -> Lazy<B> {
		return f(force(self))
	}
}

public func >>- <A, B>(x : Lazy<A>, f : @escaping (A) -> Lazy<B>) -> Lazy<B> {
	return x.bind(f)
}

public func >> <A, B>(x : Lazy<A>, y : Lazy<B>) -> Lazy<B> {
	return x.bind({ (_) in
		return y
	})
}

extension Lazy : MonadOps {
	public typealias MLA = Lazy<[A]>
	public typealias MLB = Lazy<[B]>
	public typealias MU = Lazy<()>

	public static func mapM<B>(_ f : @escaping (A) -> Lazy<B>) -> ([A]) -> Lazy<[B]> {
		return { xs in Lazy<B>.sequence(map(f)(xs)) }
	}

	public static func mapM_<B>(_ f : @escaping (A) -> Lazy<B>) -> ([A]) -> Lazy<()> {
		return { xs in Lazy<B>.sequence_(map(f)(xs)) }
	}

	public static func forM<B>(_ xs : [A]) -> (@escaping (A) -> Lazy<B>) -> Lazy<[B]> {
		return flip(Lazy.mapM)(xs)
	}

	public static func forM_<B>(_ xs : [A]) -> (@escaping (A) -> Lazy<B>) -> Lazy<()> {
		return flip(Lazy.mapM_)(xs)
	}

	public static func sequence(_ ls : [Lazy<A>]) -> Lazy<[A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in Lazy<[A]>.pure(cons(x)(xs)) } } })(Lazy<[A]>.pure([]))(ls)
	}

	public static func sequence_(_ ls : [Lazy<A>]) -> Lazy<()> {
		return foldr(>>)(Lazy<()>.pure(()))(ls)
	}
}

public func -<< <A, B>(f : @escaping (A) -> Lazy<B>, xs : Lazy<A>) -> Lazy<B> {
	return xs.bind(f)
}

public func >>->> <A, B, C>(f : @escaping (A) -> Lazy<B>, g : @escaping (B) -> Lazy<C>) -> (A) -> Lazy<C> {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> Lazy<C>, f : @escaping (A) -> Lazy<B>) -> (A) -> Lazy<C> {
	return { x in f(x) >>- g }
}
