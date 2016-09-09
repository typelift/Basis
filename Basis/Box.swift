//
//  Box.swift
//  Basis
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// The infamous Box Hack.
///
/// A box is also equivalent to the identity functor, which is also the most trivial instance of
/// Comonad.
public struct Identity<A> {
	public let runIdentity : () -> A
	
	public init(_ x : A) {
		runIdentity = { x }
	}
}

/// MARK: Equatable

public func ==<T : Equatable>(lhs: Identity<T>, rhs: Identity<T>) -> Bool {
	return lhs.runIdentity() == rhs.runIdentity()
}

public func !=<T : Equatable>(lhs: Identity<T>, rhs: Identity<T>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Functor

extension Identity : Functor {
	public typealias B = Any
	
	public typealias FB = Identity<B>
	
	public static func fmap<B>(_ f : @escaping (A) -> B) -> (Identity<A>) -> Identity<B> {
		return { b in Identity<B>(f(b.runIdentity())) }
	}
}

public func <^> <A, B>(f : @escaping (A) -> B, b : Identity<A>) -> Identity<B> {
	return Identity.fmap(f)(b)
}

public func <% <A, B>(a : A, b : Identity<B>) -> Identity<A> {
	return (curry(<^>) • const)(a)(b)
}

public func %> <A, B>(c : Identity<B>, a : A) -> Identity<A> {
	return flip(<%)(c, a)
}

extension Identity : Pointed {
	public static func pure(_ x : A) -> Identity<A> {
		return Identity(x)
	}
}

extension Identity : Copointed {
	public func extract() -> A {
		return self.runIdentity()
	}
}

extension Identity : Comonad {
	public typealias FFA = Identity<Identity<A>>
	
	public static func duplicate(_ b : Identity<A>) -> Identity<Identity<A>> {
		return Identity<Identity<A>>(b)
	}
	
	
	public static func extend<B>(_ f : @escaping (Identity<A>) -> B) -> (Identity<A>) -> Identity<B> {
		return { b in 
			return Identity<Identity<A>>.fmap(f)(Identity<A>.duplicate(b))
		}
	}
}

extension Identity : ComonadApply {
	public typealias FAB = Identity<(A) -> B>
}

public func >*< <A, B>(fab : Identity<(A) -> B> , b : Identity<A>) -> Identity<B> {
	return Identity(fab.runIdentity()(b.runIdentity()))
}

public func *< <A, B>(a : Identity<A>, b : Identity<B>) -> Identity<B> {
	return const(id) <^> a >*< b
}

public func >* <A, B>(a : Identity<A>, b : Identity<B>) -> Identity<A> {
	return const <^> a >*< b
}
