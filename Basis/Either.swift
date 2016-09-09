//
//  Either.swift
//  Basis
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Either represents a computation that either produces a result (left) or fails with an error
/// (right).
public enum Either<L, R>  {
	case left(L)
	case right(R)
}

/// Case analysis.  If the Either is Left, applies the left function to that value.  Else, if the 
/// either is right, applies the right function to that value.
public func either<A, B, C>(_ left : @escaping (A) -> C) -> (@escaping (B) -> C) -> (Either<A, B>) -> C {
	return { right in { e in
		switch e {
			case .left(let x):
				return left(x)
			case .right(let y):
				return right(y)
		}
	} }
}

/// Extracts all eithers that have left values in order.
public func lefts<A, B>(_ l : [Either<A, B>]) -> [A] {
	return concatMap({
		switch $0 {
			case .left(let a):
				return [a]
			default:
				return []
		}
	})(l)
}

/// Extracts all eithers that have right values in order.
public func rights<A, B>(_ l : [Either<A, B>]) -> [B] {
	return concatMap({
		switch $0 {
			case .right(let b):
				return [b]
			default:
				return []
		}
	})(l)
}

/// Returns whether an either holds a right value.
public func isRight<A, B>(_ e : Either<A, B>) -> Bool {
	switch e {
		case .right(_):
			return true
		default:
			return false
	}
}

/// Returns whether an either holds a left value.
public func isLeft<A, B>(_ e : Either<A, B>) -> Bool {
	switch e {
		case .left(_):
			return true
		default:
			return false
	}
}

// MARK: Equatable

public func == <A : Equatable, B : Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
	switch (lhs, rhs) {
		case let (.right(x), .right(y)) where x == y:
			return true
		case let (.left(x), .left(y)) where x == y:
			return true
		default:
			return false
	}
}

public func != <A : Equatable, B : Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
	return !(lhs == rhs)
}

// MARK: Functor

extension Either : Functor {
	public typealias A = R
	public typealias B = Any
	public typealias FB = Either<L, B>

	public static func fmap<C>(_ f : @escaping (R) -> C) -> (Either<L, R>) -> Either<L, C> {
		return { 
			switch $0 {
				case .left(let b):
					return Either<L, C>.left(b)
				case .right(let b):
					return Either<L, C>.right(f(b))
			}
		}
	}
}

public func <^> <A, B, C>(f : @escaping (B) -> C, either : Either<A, B>) -> Either<A, C> {
	return Either.fmap(f)(either)
}

public func <^ <A, B, C>(x : B, either : Either<A, C>) -> Either<A, B> {
	return Either.fmap(const(x))(either)
}

public func ^> <A, B, C>(c : Either<A, C>, a : B) -> Either<A, B> {
	return flip(<^)(c, a)
}

extension Either : Pointed {
	public static func pure(_ x : R) -> Either<L, R> {
		return Either<L, R>.right(x)
	}
}

extension Either : Applicative {
	public typealias FAB = Either<L, (R) -> C>
	
	public static func ap<C>(_ f : Either<L, (R) -> C>) -> (Either<L, R>) -> Either<L, C> {
		return { e in 
			switch f {
				case .left(let e):
					return Either<L, C>.left(e)
				case .right(let f):
					return Either<L, R>.fmap(f)(e)
			}
		}
	}
}

public func <*> <A, B, C>(f : Either<A, (B) -> C> , r : Either<A, B>) ->  Either<A, C> {
	return Either<A, B>.ap(f)(r)
}

public func *> <A, B, C>(a : Either<A, B>, b : Either<A, C>) -> Either<A, C> {
	return const(id) <^> a <*> b
}

public func <* <A, B, C>(a : Either<A, B>, b : Either<A, C>) -> Either<A, B> {
	return const <^> a <*> b
}

extension Either : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Either<L, C>
	public typealias D = Any
	public typealias FD = Either<L, D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Either<L, A>) -> Either<L, B> {
		return { a in Either<L, (A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Either<L, A>) -> (Either<L, B>) -> Either<L, C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Either<L, A>) -> (Either<L, B>) -> (Either<L, C>) -> Either<L, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Either : Monad {
	public func bind<B>(_ f : @escaping (A) -> Either<L, B>) -> Either<L, B> {
		switch self {
			case .left(let l):
				return Either<L, B>.left(l)
			case .right(let r):
				return f(r)
		}
	}
}

public func >>- <L, A, B>(xs : Either<L, A>, f : @escaping (A) -> Either<L, B>) -> Either<L, B> {
	return xs.bind(f)
}

public func >> <A, B, C>(x : Either<A, B>, y : Either<A, C>) -> Either<A, C> {
	return x >>- { (_) in
		return y
	}
}

extension Either : MonadOps {
	public typealias MLA = Either<L, [A]>
	public typealias MLB = Either<L, [B]>
	public typealias MU = Either<L, ()>

	public static func mapM<B>(_ f : @escaping (A) -> Either<L, B>) -> ([A]) -> Either<L, [B]> {
		return { xs in Either<L, B>.sequence(map(f)(xs)) }
	}

	public static func mapM_<B>(_ f : @escaping (A) -> Either<L, B>) -> ([A]) -> Either<L, ()> {
		return { xs in Either<L, B>.sequence_(map(f)(xs)) }
	}

	public static func forM<B>(_ xs : [A]) -> (@escaping (A) -> Either<L, B>) -> Either<L, [B]> {
		return flip(Either.mapM)(xs)
	}

	public static func forM_<B>(_ xs : [A]) -> (@escaping (A) -> Either<L, B>) -> Either<L, ()> {
		return flip(Either.mapM_)(xs)
	}

	public static func sequence(_ ls : [Either<L, A>]) -> Either<L, [A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in Either<L, [A]>.pure(cons(x)(xs)) } } })(Either<L, [A]>.pure([]))(ls)
	}

	public static func sequence_(_ ls : [Either<L, A>]) -> Either<L, ()> {
		return foldr(>>)(Either<L, ()>.pure(()))(ls)
	}
}

public func -<< <L, A, B>(f : @escaping (A) -> Either<L, B>, xs : Either<L, A>) -> Either<L, B> {
	return xs.bind(f)
}

public func >>->> <L, A, B, C>(f : @escaping (A) -> Either<L, B>, g : @escaping (B) -> Either<L, C>) -> (A) -> Either<L, C> {
	return { x in f(x) >>- g }
}

public func <<-<< <L, A, B, C>(g : @escaping (B) -> Either<L, C>, f : @escaping (A) -> Either<L, B>) -> (A) -> Either<L, C> {
	return { x in f(x) >>- g }
}

extension Either : MonadFix {
	public static func mfix(_ f : (R) -> Either<L, R>) -> Either<L, R> {
		func fromRight(_ e : Either<L, R>) -> R {
			switch e {
				case .right(let br):
					return br
				case .left(_):
					return error("Cannot take fixpoint of left Either")
			}
		}
		return f(fromRight(Either.mfix(f)))
	}
}
