//
//  Result.swift
//  Basis
//
//  Created by Robert Widmann on 9/24/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Result is similar to an Either, except specialized to have an Error case that can
/// only contain an NSError.
public final class Result<A> : K1<A> {
	let lVal : NSError?
	let rVal : A?

	init(left : NSError) {
		self.lVal = left
	}

	init(right : A) {
		self.rVal = right
	}

	public class func left(x : NSError) -> Result<A> {
		return Result(left: x)
	}

	public class func right(x : A) -> Result<A> {
		return Result(right: x)
	}

	public class func right(x : Box<A>) -> Result<A> {
		return Result(right: x.unBox())
	}

	public func destruct() -> ResultD<A> {
		if lVal != nil {
			return .Error(lVal!)
		}
		return .Value(Box(rVal!))
	}
}

/// Case analysis.  If the Result is Left, applies the left function to that value.  Else, if the
/// either is right, applies the right function to that value.
public func either<A, B>(left : NSError -> B)(right : A -> B)(e : Result<A>) -> B {
	switch e.destruct() {
	case .Error(let x):
		return left(x)
	case .Value(let y):
		return right(y.unBox())
	}
}

/// Extracts all eithers that have left errors in order.
public func lefts<A, B>(l : [Result<A>]) -> [NSError] {
	return concatMap({
		switch $0.destruct() {
		case .Error(let a):
			return [a]
		default:
			return []
		}
	})(l: l)
}

/// Extracts all eithers that have right values in order.
public func rights<A>(l : [Result<A>]) -> [A] {
	return concatMap({
		switch $0.destruct() {
		case .Value(let b):
			return [b.unBox()]
		default:
			return []
		}
	})(l: l)
}

/// Returns whether a result holds a right value.
public func isRight<A, B>(e : Result<A>) -> Bool {
	switch e.destruct() {
	case .Value(_):
		return true
	default:
		return false
	}
}

/// Returns whether a result holds a left error.
public func isLeft<A, B>(e : Result<A>) -> Bool {
	switch e.destruct() {
	case .Error(_):
		return true
	default:
		return false
	}
}

extension Result : Functor {
	typealias B = Any
	typealias FA = Result<A>
	typealias FB = Result<B>

	public class func fmap<B>(f : A -> B) -> Result<A> -> Result<B> {
		return {
			switch $0.destruct() {
			case .Error(let b):
				return Result<B>.left(b)
			case .Value(let b):
				return Result<B>.right(f(b.unBox()))
			}
		}
	}

}

public func <%><A, B>(f: A -> B, either : Result<A>) -> Result<B> {
	return Result.fmap(f)(either)
}

public func <% <A, B>(x : A, either : Result<B>) -> Result<A> {
	return Result.fmap(const(x))(either)
}

extension Result : Applicative {
	typealias FAB = Result<A -> B>

	public class func pure(x : A) -> Result<A> {
		return Result.right(x)
	}
}

public func <*><A, B>(f : Result<A -> B> , r : Result<A>) ->  Result<B> {
	switch f.destruct() {
	case .Error(let e):
		return Result.left(e)
	case .Value(let f):
		return Result.fmap(f.unBox())(r)
	}
}

public func *><A, B>(a : Result<A>, b : Result<B>) -> Result<B> {
	return const(id) <%> a <*> b
}

public func <*<A, B>(a : Result<A>, b : Result<B>) -> Result<A> {
	return const <%> a <*> b
}

extension Result : Monad {
	public func bind<B>(f : A -> Result<B>) -> Result<B> {
		switch self.destruct() {
		case .Error(let l):
			return Result<B>.left(l)
		case .Value(let r):
			return f(r.unBox())
		}
	}
}

public func >>-<A, B>(xs : Result<A>, f : A -> Result<B>) -> Result<B> {
	return xs.bind(f)
}

public func >><A, B>(x : Result<A>, y : Result<B>) -> Result<B> {
	return x >>- { (_) in
		return y
	}
}

public enum ResultD<A> {
	case Error(NSError)
	case Value(Box<A>)
}


