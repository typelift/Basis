//
//  Function.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// The type of a function from T -> U.  Swift does not consider `->` to be a type constructor as in
/// most other (*cough* saner *cough*) languages, so this is more of an improvisation than a
/// formalism.
///
/// Functions like this (called arrows) actually respect a number of laws, and are an entire
/// algebraic struture in their own right.
public final class Function1<T, U> : K2<T, U>, Arrow {
	typealias A = T
	typealias B = U
	typealias C = Any


	let ap : T -> U
	public init(_ apply : T -> U) {
		self.ap = apply
	}
	
	public func apply(x : T) -> U {
		return self.ap(x)
	}
}

extension Function1 : Category {
	typealias CAA = Function1<A, A>
	typealias CAB = Function1<A, B>
	typealias CBC = Function1<B, C>
	typealias CAC = Function1<A, C>
	
	public func id() -> Function1<T, T> {
		return Function1<T, T>({ $0 })
	}
}


public func •<A, B, C>(c : Function1<B, C>, c2 : Function1<A, B>) -> Function1<A, C> {
	return Function1({ c.apply(c2.apply($0)) })
}

public func <<< <A, B, C>(c1 : Function1<B, C>, c2 : Function1<A, B>) -> Function1<A, C> {
	return c1 • c2
}

public func >>> <A, B, C>(c1 : Function1<A, B>, c2 : Function1<B, C>) -> Function1<A, C> {
	return c2 • c1
}

extension Function1 : Arrow {
	typealias AB = T
	typealias AC = U
	typealias D = T
	typealias E = Any
	
	typealias ABC = Function1<T, U>
	typealias FIRST = Function1<(AB, D), (AC, D)>
	typealias SECOND = Function1<(D, AB), (D, AC)>
	
	typealias ADE = Function1<D, E>
	typealias SPLIT = Function1<(AB, D), (AC, E)>
	
	typealias ABD = Function1<AB, D>
	typealias FANOUT = Function1<AB, (AC, D)>
	
	public class func arr(f : AB -> AC) -> Function1<AB, AC> {
		return Function1<AB, AC>({ f($0) })
	}
	
	public func first() -> Function1<(AB, D), (AC, D)> {
		return self *** id()
	}
	
	public func second() -> Function1<(D, AB), (D, AC)> {
		return id() *** self
	}
}

public func *** <B, C, D, E>(f : Function1<B, C>, g : Function1<D, E>) -> Function1<(B, D), (C, E)> {
	return Function1({ (let t : (B, D)) in
		return (f.apply(t.0), g.apply(t.1))
	})
}

public func &&& <B, C, D>(f : Function1<B, C>, g : Function1<B, D>) -> Function1<B, (C, D)> {
	return Function1.arr({ (let b) in
		return (b, b)
	}) >>> f *** g
}

public final class Function2<T, U, C> : K3<T, U, C> {
	let ap : (T, U) -> C
	public init(_ apply : (T, U) -> C) {
		self.ap = apply
	}
	
	public func apply(x : T, y : U) -> C {
		return self.ap(x, y)
	}
}
