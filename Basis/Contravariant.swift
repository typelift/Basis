//
//  Contravariant.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
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
protocol Contravariant {
	/// Type of Source Objects
	typealias A
	/// Type of Target Objects
	typealias B
	
	/// Type of our Functor
	typealias FA = K1<A>
	
	/// Type of a target Functor
	typealias FB = K1<B>
	
	/// Contravariant map "inside" a Functor.
	///
	/// F on our diagram.
	class func contramap(A -> B) -> FB -> FA
	func >%<(A -> B, FB) -> FA
	
	/// Contravariant Constant Replace | Replaces all values in the target Functor with a singular 
	/// constant value from the source Functor.
	///
	/// Default definition: 
	///		`curry(>%<) • const`
	func >%(B, FB) -> FA
}
