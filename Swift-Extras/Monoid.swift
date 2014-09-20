//
//  Monoid.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Monoids are algebraic structures consisting of a set of elements, an associative binary operator
/// to combine two of those elements together, and a single specialized element called the identity 
/// (here, mempty) that respects the Monoid Laws:
///
/// - Closure    Composing two members of the set of elements yields another element still in that
///              set of elements.  This is much like addition over the integers where all the
///              numbers in the equation 1 + 1 = 2 are integers.  You would never, in a million 
///              years, expect it to produce a real or complex or any other type of number.  With
///
/// - Associativity    It does not matter which way you group your parenthesis when composing two
///                    members of the monoid's set.  Either way, the answer is the same.
///
/// - Identity    There is some element in the monoid's set of elements that, when composed
///               with other elements, doesn't alter their value.  Like 0 in addition of the
///               integers: 0 + 1 = 1 + 0 = 1
public protocol Monoid {
	/// The identity element.
	class func mempty() -> Self
	/// An associative binary operator.
	class func mappend(Self) -> Self -> Self
}

// Uncomment to crash Swiftc
//public func mconcat<M : Monoid>(l : [M]) -> M {
//	return foldr(M.mappend)(z: M.mempty())(l: l)
//}

extension Array : Monoid {
	public static func mempty() -> Array<T> {
		return []
	}
	
	public static func mappend(l : Array<T>) -> Array<T> -> Array<T> {
		return { l ++ $0 }
	}
}
