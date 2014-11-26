//
//  Const.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

public struct Const<A, B> {
	public let val : A
	
	public init(_ val : A) {
		self.val = val
	}
}

extension Const : Functor {
	typealias FA = Const<A, B>
	typealias FB = Const<A, B>
	
	public static func fmap<C>(A -> C) -> Const<A, B> -> Const<A, B> {
		return { c in Const<A, B>(c.val) }
	}
}

public func <%><A, B, C>(f : A -> C, c : Const<A, B>) -> Const<A, B> {
	return Const.fmap(f)(c)
}

public func <%<A, B>(a : A, c : Const<A, B>) -> Const<A, B> {
	return (curry(<%>) • const)(a)(c)
}

extension Const : Contravariant {
	public static func contramap(A -> B) -> Const<A, B> -> Const<A, B> {
		return { c in Const<A, B>(c.val) }
	}
}

public func >%<<A, B>(f : A -> B,c : Const<A, B>) -> Const<A, B> {
	return Const.contramap(f)(c)
}


public func >%<A, B>(b : B, c : Const<A, B>) -> Const<A, B> {
	return (curry(>%<) • const)(b)(c)
}
