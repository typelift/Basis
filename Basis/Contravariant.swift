//
//  Contravariant.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Functors that are contravariant in their arguments.
///
///                  C(C)
///                    •
///                   / \
///                  /   \
///                 /     \
///                /       \
///  contramap f  /         \  contramap (g • f)
///              /           \
///             /             \
///            /               \
///           •-----------------•
///          C(B)              C(A)
///                contramap g
///
/// A Functor with the arrows turned around.
public protocol Contravariant {
	/// Type of Source Objects
	typealias A
	/// Type of Target Objects
	typealias B
	
	/// Type of a target Functor
	typealias FB = K1<B>
	
	/// Contravariant map "inside" a Functor.
	///
	/// F on our diagram.
	class func contramap(A -> B) -> FB -> Self
	func >%<(A -> B, FB) -> Self
	
	/// Contravariant Constant Replace | Replaces all values in the target Functor with a singular 
	/// constant value from the source Functor.
	///
	/// Default definition: 
	///		`curry(>%<) • const`
	func >%(B, FB) -> Self
}
