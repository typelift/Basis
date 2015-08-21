//
//  ComonadFix.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Comonads that admit left-tightening recursion.
public protocol ComonadFix : Comonad {
	typealias FFAA = K1<K1<A> -> A>
	
	/// Calculates the fixed point of a comonadic context.
	///
	/// Default definition: 
	///		x.extract()(F<F<A> -> A>.extend(F<A>.cofix)(x))
	static func cofix(_: FFAA) -> A
}

// Uncomment to crash Swiftc rdar://18619154
//extension Box : ComonadFix {
//	public typealias FFAA = Box<Box<A> -> A>
//
//	public class func cofix(x : Box<Box<A> -> A>) -> A {
//		return x.extract()(Box<Box<A> -> A>.extend(Box<A>.cofix)(x))
//	}
//}
