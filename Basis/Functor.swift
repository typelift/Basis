//
//  Functor.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Functors map the functions and objects in one set to a different set of functions and objects.
/// This is represented by any structure parametrized by some set A, and a function `fmap` that 
/// takes objects in A to objects in B and wraps the result back in a functor.  `fmap` respects the
/// following commutative diagram:
///
///
///               F(A)
///                 •
///                / \
///               /   \
///              /     \
///             /       \
///    fmap f  /         \  fmap (f • g)
///           /           \
///          /             \
///         /               \
///         •----------------•
///       F(B)              F(C)
///               fmap g
///
/// Formally, a Functor is a mapping between Categories, but we have to restrict ourselves to the
/// Category of Swift Types (S), so in practice a Functor is just an Endofunctor.  Functors are
/// often described as "Things that can be mapped over".
public protocol Functor {
	/// Type of Source Objects
	typealias A
	/// Type of Target Objects
	typealias B
	
	/// Type of a target Functor
	typealias FB = K1<B>
	
	/// Map "inside" a Functor.
	///
	/// F on our diagram.
	static func fmap(A -> B) -> Self -> FB
	func <%>(A -> B, Self) -> FB

	/// Constant Replace | Replaces all values in the target Functor with a singular constant value
	/// from the source Functor.
	///
	/// Default definition: 
	///		`curry(<%>) • const`
	func <%(A, FB) -> Self
}
