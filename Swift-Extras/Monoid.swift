//
//  Monoid.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Monoids are algebraic structures consisting of a set of elements, an operation to combine two of
/// those elements together, and a single specialized element called the identity (here, mempty)
/// that respects closure and associativity laws.
///
/// Lots of things are monoids.  For example, addition over the natural numbers forms a monoid.
/// The set of elements is ℕ, the binary operator is +, and the identity element is 0.
public protocol Monoid {
	/// The identity element.
	class func mempty() -> Self
	/// An associative binary operator.
	class func mappend(Self) -> Self -> Self
}

public func mconcat<M : Monoid>(l : [M]) -> M {
	return foldr(M.mappend)(z: M.mempty())(l: l)
}

extension Array : Monoid {
	public static func mempty() -> Array<T> {
		return []
	}
	
	public static func mappend(l : Array<T>) -> Array<T> -> Array<T> {
		return { l ++ $0 }
	}
}
