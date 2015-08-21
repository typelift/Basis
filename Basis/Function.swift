//
//  Function.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// The type of a function from T -> U.
public struct Function<T, U> {
	public typealias A = T
	public typealias B = U
	public typealias C = Any

	let ap : T -> U

	public init(_ apply : T -> U) {
		self.ap = apply
	}
	
	public func apply(x : T) -> U {
		return self.ap(x)
	}
}

extension Function : Category {
	public typealias CAA = Function<A, A>
	public typealias CBC = Function<B, C>
	public typealias CAC = Function<A, C>
	
	public static func id() -> Function<T, T> {
		return Function<T, T>({ $0 })
	}
}

public func • <A, B, C>(c : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return ^{ c.apply(c2.apply($0)) }
}

public func <<< <A, B, C>(c1 : Function<B, C>, c2 : Function<A, B>) -> Function<A, C> {
	return c1 • c2
}

public func >>> <A, B, C>(c1 : Function<A, B>, c2 : Function<B, C>) -> Function<A, C> {
	return c2 • c1
}

extension Function : Arrow {
	public typealias D = T
	public typealias E = Swift.Any
	
	public typealias FIRST = Function<(A, D), (B, D)>
	public typealias SECOND = Function<(D, A), (D, B)>
	
	public typealias ADE = Function<D, E>
	public typealias SPLIT = Function<(A, D), (B, E)>
	
	public typealias ABD = Function<A, D>
	public typealias FANOUT = Function<A, (B, D)>
	
	public static func arr(f : T -> U) -> Function<A, B> {
		return Function<A, B>(f)
	}
	
	public func first() -> Function<(T, T), (U, T)> {
		return self *** Function.id()
	}
	
	public func second() -> Function<(T, T), (T, U)> {
		return Function.id() *** self
	}
}

public func *** <B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<(B, D), (C, E)> {
	return ^{ (x, y) in  (f.apply(x), g.apply(y)) }
}

public func &&& <A, B, C>(f : Function<A, B>, g : Function<A, C>) -> Function<A, (B, C)> {
	return ^{ b in (b, b) } >>> f *** g
}

extension Function : ArrowChoice {
	public typealias LEFT = Function<Either<A, D>, Either<B, D>>
	public typealias RIGHT = Function<Either<D, A>, Either<D, B>>
	
	public typealias SPLAT = Function<Either<A, D>, Either<B, E>>
	
	public typealias ACD = Function<B, D>
	public typealias FANIN = Function<Either<A, B>, D>
	
	public static func left(f : Function<A, B>) -> Function<Either<A, D>, Either<B, D>> {
		return f +++ Function.id()
	}
	
	public static func right(f : Function<A, B>) -> Function<Either<D, A>, Either<D, B>> {
		return Function.id() +++ f
	}
}

public func +++ <B, C, D, E>(f : Function<B, C>, g : Function<D, E>) -> Function<Either<B, D>, Either<C, E>> {
	return ^Either.Left • f ||| ^Either.Right • g
}

public func ||| <B, C, D>(f : Function<B, D>, g : Function<C, D>) -> Function<Either<B, C>, D> {
	return ^either(f^)(g^)
}

extension Function : ArrowApply {
	public typealias APP = Function<(Function<A, B>, A), B>
	
	public static func app() -> Function<(Function<T, U>, A), B> {
		return Function<(Function<T, U>, A), B>({ (f, x) in f.apply(x) })
	}
	
	public static func leftApp<C>(f : Function<A, B>) -> Function<Either<A, C>, Either<B, C>> {
		let l : Function<A, (Function<Void, Either<B, C>>, Void)> = ^{ (let a : A) -> (Function<Void, Either<B, C>>, Void) in (Function<Void, A>.arr({ _ in a }) >>> f >>> Function<B, Either<B, C>>.arr(Either.Left), Void()) }
		let r : Function<C, (Function<Void, Either<B, C>>, Void)> = ^{ (let c : C) -> (Function<Void, Either<B, C>>, Void) in (Function<Void, C>.arr({ _ in c }) >>> Function<C, Either<B, C>>.arr(Either.Right), Void()) }

		return (l ||| r) >>> Function<Void, Either<B, C>>.app()
	}
}

extension Function : ArrowLoop {
	public typealias LOOP = Function<(A, D), (B, D)>
	
	public static func loop<B, C>(f : Function<(B, D), (C, D)>) -> Function<B, C> {
		return ^({ k in Function.loop(f).apply(k) })
	}
}
