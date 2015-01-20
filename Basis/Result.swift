//
//  Result.swift
//  Basis
//
//  Created by Robert Widmann on 9/24/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Result is similar to an Either, except specialized to have an Error case that can
/// only contain an NSError.
public struct Result<A> {
	let lVal : NSError?
	let rVal : A?

	init(left : NSError) {
		self.lVal = left
	}

	init(right : A) {
		self.rVal = right
	}

	public static func error(x : NSError) -> Result<A> {
		return Result(left: x)
	}

	public static func value(x : A) -> Result<A> {
		return Result(right: x)
	}

	public static func value(x : Box<A>) -> Result<A> {
		return Result(right: x.unBox())
	}

	public func match() -> ResultD<A> {
		if lVal != nil {
			return .Error(lVal!)
		}
		return .Value(Box(rVal!))
	}
}

/// Case analysis.  If the Result is Left, applies the left function to that value.  Else, if the
/// either is right, applies the right function to that value.
public func either<A, B>(left : NSError -> B) -> (A -> B) -> Result<A> -> B {
	return { right in { e in
		switch e.match() {
			case .Error(let x):
				return left(x)
			case .Value(let y):
				return right(y.unBox())
		}
	} }
}

/// Extracts all eithers that have errors in order.
public func errors<A, B>(l : [Result<A>]) -> [NSError] {
	return concatMap({
		switch $0.match() {
			case .Error(let a):
				return [a]
			default:
				return []
		}
	})(l)
}

/// Extracts all eithers that have values in order.
public func values<A>(l : [Result<A>]) -> [A] {
	return concatMap({
		switch $0.match() {
			case .Value(let b):
				return [b.unBox()]
			default:
				return []
		}
	})(l)
}

/// Returns whether a result holds a value.
public func isRight<A, B>(e : Result<A>) -> Bool {
	switch e.match() {
		case .Value(_):
			return true
		default:
			return false
	}
}

/// Returns whether a result holds an error.
public func isLeft<A, B>(e : Result<A>) -> Bool {
	switch e.match() {
		case .Error(_):
			return true
		default:
			return false
	}
}

/// Maps a Result to an Either.
public func asEither<A>(e : Result<A>) -> Either<NSError, A> {
	return either({ e in Either.left(e) })({ v in Either.right(v) })(e)
}

// MARK: Equatable

public func == <V : Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case let (.Error(l), .Error(r)) where l == r:
			return true
		case let (.Value(l), .Value(r)) where l.unBox() == r.unBox():
			return true
		default:
			return false
	}
}

public func != <V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
	return !(lhs == rhs)
}

// MARK: Functor

extension Result : Functor {
	typealias B = Any
	typealias FB = Result<B>

	public static func fmap<B>(f : A -> B) -> Result<A> -> Result<B> {
		return {
			switch $0.match() {
				case .Error(let b):
					return Result<B>.error(b)
				case .Value(let b):
					return Result<B>.value(f(b.unBox()))
			}
		}
	}

}

public func <%> <A, B>(f: A -> B, either : Result<A>) -> Result<B> {
	return Result.fmap(f)(either)
}

public func <% <A, B>(x : A, either : Result<B>) -> Result<A> {
	return Result.fmap(const(x))(either)
}

extension Result : Pointed {
	public static func pure(x : A) -> Result<A> {
		return Result.value(x)
	}
}

extension Result : Applicative {
	typealias FAB = Result<A -> B>
	
	public static func ap<A, B>(f : Result<A -> B>) -> Result<A> ->  Result<B> {
		return { r in
			switch f.match() {
				case .Error(let e):
					return Result<B>.error(e)
				case .Value(let f):
					return Result<A>.fmap(f.unBox())(r)
			}
		}
	}	
}

public func <*> <A, B>(f : Result<A -> B> , r : Result<A>) ->  Result<B> {
	return Result<A>.ap(f)(r)
}

public func *> <A, B>(a : Result<A>, b : Result<B>) -> Result<B> {
	return const(id) <%> a <*> b
}

public func <* <A, B>(a : Result<A>, b : Result<B>) -> Result<A> {
	return const <%> a <*> b
}

extension Result : ApplicativeOps {
	typealias C = Any
	typealias FC = Result<C>
	typealias D = Any
	typealias FD = Result<D>

	public static func liftA<B>(f : A -> B) -> Result<A> -> Result<B> {
		return { a in Result<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Result<A> -> Result<B> -> Result<C> {
		return { a in { b in f <%> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Result<A> -> Result<B> -> Result<C> -> Result<D> {
		return { a in { b in { c in f <%> a <*> b <*> c } } }
	}
}

extension Result : Monad {
	public func bind<B>(f : A -> Result<B>) -> Result<B> {
		switch self.match() {
			case .Error(let l):
				return Result<B>.error(l)
			case .Value(let r):
				return f(r.unBox())
		}
	}
}

public func >>- <A, B>(x : Result<A>, f : A -> Result<B>) -> Result<B> {
	return x.bind(f)
}

public func >> <A, B>(x : Result<A>, y : Result<B>) -> Result<B> {
	return x.bind({ (_) in
		return y
	})
}

extension Result : MonadOps {
	typealias MLA = Result<[A]>
	typealias MLB = Result<[B]>
	typealias MU = Result<()>

	public static func mapM<B>(f : A -> Result<B>) -> [A] -> Result<[B]> {
		return { xs in Result<B>.sequence(map(f)(xs)) }
	}

	public static func mapM_<B>(f : A -> Result<B>) -> [A] -> Result<()> {
		return { xs in Result<B>.sequence_(map(f)(xs)) }
	}

	public static func forM<B>(xs : [A]) -> (A -> Result<B>) -> Result<[B]> {
		return flip(Result.mapM)(xs)
	}

	public static func forM_<B>(xs : [A]) -> (A -> Result<B>) -> Result<()> {
		return flip(Result.mapM_)(xs)
	}

	public static func sequence(ls : [Result<A>]) -> Result<[A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in Result<[A]>.pure(cons(x)(xs)) } } })(Result<[A]>.pure([]))(ls)
	}

	public static func sequence_(ls : [Result<A>]) -> Result<()> {
		return foldr(>>)(Result<()>.pure(()))(ls)
	}
}

public func -<< <A, B>(f : A -> Result<B>, xs : Result<A>) -> Result<B> {
	return xs.bind(f)
}

public func >-> <A, B, C>(f : A -> Result<B>, g : B -> Result<C>) -> A -> Result<C> {
	return { x in f(x) >>- g }
}

public func <-< <A, B, C>(g : B -> Result<C>, f : A -> Result<B>) -> A -> Result<C> {
	return { x in f(x) >>- g }
}

public enum ResultD<A> {
	case Error(NSError)
	case Value(Box<A>)
}


