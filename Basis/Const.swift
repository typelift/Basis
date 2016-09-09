//
//  Const.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// The Constant Functor maps every argument back to its first value.
public struct Const<L, R> {
	public let val : L
	
	public init(_ val : L) {
		self.val = val
	}
}

extension Const : Functor {
	public typealias A = L
	public typealias B = R
	public typealias FB = Const<A, B>
	
	public static func fmap<B>(_ : (A) -> B) -> (Const<L, R>) -> Const<L, R> {
		return { c in Const(c.val) }
	}
}

public func <^> <A, B, C>(f : (A) -> C, c : Const<A, B>) -> Const<A, B> {
	return Const<A, B>.fmap(f)(c)
}

public func <% <A, B>(a : A, c : Const<A, B>) -> Const<A, B> {
	return (curry(<^>) • const)(a)(c)
}

public func %> <A, B>(c : Const<A, B>, a : A) -> Const<A, B> {
	return flip(<%)(c, a)
}

extension Const : Contravariant {
	public static func contramap<B>(_ : (A) -> B) -> (Const<A, B>) -> Const<A, B> {
		return { c in Const<A, B>(c.val) }
	}
}

public func >%< <A, B>(f : (A) -> B,c : Const<A, B>) -> Const<A, B> {
	return Const<A, B>.contramap(f)(c)
}


public func >% <A, B>(b : B, c : Const<A, B>) -> Const<A, B> {
	return (curry(>%<) • const)(b)(c)
}
