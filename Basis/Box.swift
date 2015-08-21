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
public final class Box<A> : K1<A> {
	public let unBox : () -> A
	
	public init(_ x : A) {
		unBox = { x }
	}
}

/// MARK: Equatable

public func ==<T : Equatable>(lhs: Box<T>, rhs: Box<T>) -> Bool {
	return lhs.unBox() == rhs.unBox()
}

public func !=<T : Equatable>(lhs: Box<T>, rhs: Box<T>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Functor

extension Box : Functor {
	public typealias B = Swift.Any
	
	public typealias FB = Box<B>
	
	public class func fmap<B>(f : A -> B) -> Box<A> -> Box<B> {
		return { b in Box<B>(f(b.unBox())) }
	}
}

public func <^> <A, B>(f : A -> B, b : Box<A>) -> Box<B> {
	return Box.fmap(f)(b)
}

public func <% <A, B>(a : A, b : Box<B>) -> Box<A> {
	return (curry(<^>) • const)(a)(b)
}

extension Box : Pointed {
	public class func pure(x : A) -> Box<A> {
		return Box(x)
	}
}

extension Box : Copointed {
	public func extract() -> A {
		return self.unBox()
	}
}

extension Box : Comonad {
	public typealias FFA = Box<Box<A>>
	
	public class func duplicate(b : Box<A>) -> Box<Box<A>> {
		return Box<Box<A>>(b)
	}
	
	
	public class func extend<B>(f : Box<A> -> B) -> Box<A> -> Box<B> {
		return { b in 
			return Box<Box<A>>.fmap(f)(Box<A>.duplicate(b))
		}
	}
}

extension Box : ComonadApply {
	public typealias FAB = Box<A -> B>
}

public func >*< <A, B>(fab : Box<A -> B> , b : Box<A>) -> Box<B> {
	return Box(fab.unBox()(b.unBox()))
}

public func *< <A, B>(a : Box<A>, b : Box<B>) -> Box<B> {
	return const(id) <^> a >*< b
}

public func >* <A, B>(a : Box<A>, b : Box<B>) -> Box<A> {
	return const <^> a >*< b
}
