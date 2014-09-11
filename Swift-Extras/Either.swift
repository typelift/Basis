//
//  Either.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Either represents a computation that either produces a result (left) or fails with an error
/// (right).
public final class Either<A, B> : K2<A, B> {
	let lVal : A?
	let rVal : B?
	
	init(left : A) {
		self.lVal = left
	}
	
	init(right : B) {
		self.rVal = right
	}

	public class func left(x : A) -> Either<A, B> {
		return Either(left: x)
	}
	
	public class func right(x : B) -> Either<A, B> {
		return Either(right: x)
	}
	
	public class func left(x : Box<A>) -> Either<A, B> {
		return Either(left: x.unBox())
	}
	
	public class func right(x : Box<B>) -> Either<A, B> {
		return Either(right: x.unBox())
	}
	
	public func destruct() -> EitherD<A, B> {
		if lVal != nil {
			return .Left(Box(lVal!))
		}
		return .Right(Box(rVal!))
	}
}

public func either<A, B, C>(left : A -> C)(right : B -> C)(e : Either<A, B>) -> C {
	switch e.destruct() {
		case .Left(let x):
			return left(x.unBox())
		case .Right(let y):
			return right(y.unBox())
	}
}

public func lefts<A, B>(l : [Either<A, B>]) -> [A] {
	return concatMap({
		switch $0.destruct() {
			case .Left(let a):
				return [a.unBox()]
			default:
				return []
		}
	})(l: l)
}

public func rights<A, B>(l : [Either<A, B>]) -> [B] {
	return concatMap({
		switch $0.destruct() {
			case .Right(let b):
				return [b.unBox()]
			default:
				return []
		}
	})(l: l)
}

public func isRight<A, B>(e : Either<A, B>) -> Bool {
	switch e.destruct() {
		case .Right(_):
			return true
		default:
			return false
	}
}

public func isLeft<A, B>(e : Either<A, B>) -> Bool {
	switch e.destruct() {
		case .Left(_):
			return true
		default:
			return false
	}
}

extension Either : Functor {
	typealias C = Any
	typealias FA = Either<A, B>
	typealias FB = Either<A, C>

	public class func fmap<C>(f : B -> C) -> Either<A, B> -> Either<A, C> {
		return { 
			switch $0.destruct() {
				case .Left(let b):
					return Either<A, C>.left(b)
				case .Right(let b):
					return Either<A, C>.right(f(b.unBox()))
			}
		}
	}

}

public func <%><A, B, C>(f: B -> C, either : Either<A, B>) -> Either<A, C> {
	return Either.fmap(f)(either)
}

public func <^ <A, B, C>(x : B, either : Either<A, C>) -> Either<A, B> {
	return Either.fmap(const(x))(either)
}

extension Either : Applicative {
	typealias FAB = Either<A, B -> C>
	
	public class func pure(x : Either<A, B>.A) -> Either<A, B>.FA {
		return Either.right(x)
	}
}


public func <*><A, B, C>(f : Either<A, B -> C> , r : Either<A, B>) ->  Either<A, C> {
	switch f.destruct() {
		case .Left(let e):
			return Either.left(e)
		case .Right(let f):
			return Either.fmap(f.unBox())(r)
	}
}


public func *><A, B, C>(a : Either<A, B>, b : Either<A, C>) -> Either<A, C> {
	return const(id) <%> a <*> b
}

public func <*<A, B, C>(a : Either<A, B>, b : Either<A, C>) -> Either<A, B> {
	return const <%> a <*> b
}

public enum EitherD<A, B> {
	case Left(Box<A>)
	case Right(Box<B>)
}

