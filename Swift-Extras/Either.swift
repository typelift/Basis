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
	
	public func destruct() -> EitherD<A, B> {
		if lVal != nil {
			return .Left(Box(lVal!))
		}
		return .Right(Box(rVal!))
	}
}

public enum EitherD<A, B> {
	case Left(Box<A>)
	case Right(Box<B>)
}

