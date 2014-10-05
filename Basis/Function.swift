//
//  Function.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// The type of a function from T -> U.  Swift does not consider `->` to be a type constructor as in
/// most other (*cough* saner *cough*) languages, so this is more of an improvisation than a
/// formalism.
///
/// Functions like this (called arrows) actually respect a number of laws, and are an entire
/// algebraic struture in their own right.
public final class Function<T, U> : K2<T, U>, Arrow {
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

extension Function : Category {
	typealias CAA = Function<A, A>
	typealias CAB = Function<A, B>
	typealias CBC = Function<B, C>
	typealias CAC = Function<A, C>
	
	public class func id() -> Function<T, T> {
		return Function<T, T>({ $0 })
	}
}

public func •<A, B, C>(c : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return ^{ c.apply(c2.apply($0)) }
}

public func <<< <A, B, C>(c1 : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return c1 • c2
}

public func >>> <A, B, C>(c1 : Function<A, B>, c2 : Function<B, C>) -> Function<A, C> {
	return c2 • c1
}

extension Function : Arrow {
	typealias AB = T
	typealias AC = U
	typealias D = T
	typealias E = Any
	
	typealias ABC = Function<T, U>
	typealias FIRST = Function<(AB, D), (AC, D)>
	typealias SECOND = Function<(D, AB), (D, AC)>
	
	typealias ADE = Function<D, E>
	typealias SPLIT = Function<(AB, D), (AC, E)>
	
	typealias ABD = Function<AB, D>
	typealias FANOUT = Function<AB, (AC, D)>
	
	public class func arr(f : T -> U) -> Function<AB, AC> {
		return Function<AB, AC>({ f($0) })
	}
	
	public func first() -> Function<(T, T), (U, T)> {
		return self *** Function.id()
	}
	
	public func second() -> Function<(T, T), (T, U)> {
		return Function.id() *** self
	}
}

public func *** <B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<(B, D), (C, E)> {
	return ^{ (let t : (B, D)) in
		return (f.apply(fst(t)), g.apply(snd(t)))
	}
}

public func &&& <B, C, D>(f : Function<B, C>, g : Function<B, D>) -> Function<B, (C, D)> {
	return ^{ b in (b, b) } >>> f *** g
}

extension Function : ArrowChoice {
	typealias LEFT = Function<Either<AB, D>, Either<AC, D>>
	typealias RIGHT = Function<Either<D, AB>, Either<D, AC>>
	
	typealias SPLAT = Function<Either<AB, D>, Either<AC, E>>
	
	typealias ACD = Function<AC, D>
	typealias FANIN = Function<Either<AB, AC>, D>
	
	public func left(f : Function<AB, AC>) -> Function<Either<AB, D>, Either<AC, D>> {
		return f +++ Function.id()
	}
	
	public func right(f : Function<AB, AC>) -> Function<Either<D, AB>, Either<D, AC>> {
		return Function.id() +++ f
	}
	
}

public func +++<B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<Either<B, D>, Either<C, E>> {
	return ^{ Either.left(f.apply($0)) } ||| ^{ Either.right(g.apply($0)) }
}

public func |||<B, C, D>(f : Function<B, D>, g : Function<C, D>) -> Function<Either<B, C>, D> {
	return Function.arr(either(f.apply)(g.apply))
}

extension Function : ArrowApply {
	typealias APP = Function<(ABC, AB), AC>
	
	public func app() -> Function<(Function<T, U>, AB), AC> {
		return Function<(Function<T, U>, AB), AC>({ (let t : (Function<T, U>, AB)) -> AC in
			return fst(t).apply(snd(t))
		})
	}
}

//extension Function : ArrowLoop {
//	typealias LOOP = Function<(AB, D), (AC, D)>
//	
//	public func loop(f : Function<(AB, D), (AC, D)>) -> Function<T, U> {
//		return f.apply(loop(f))
//	}
//}


