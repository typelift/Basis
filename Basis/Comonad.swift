//
//  Comonad.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// A Comonad is the categorical dual to a Monad.  If a Monad is the model of a computation that 
/// produces a value of type T, a Comonad is a value produced from a context.
///
/// "A comonoid in the monoidal category of endofunctors"
public protocol Comonad : Copointed {
	typealias FFA = K1<FA>

	/// Cojoin | Takes a value in a context and wraps it in another context.
	///
	/// Default Definition:
	///		`extend(id)`
	class func duplicate(FA) -> FFA
	
	/// Cobind | Computes a value in a context, fmaps that value, then wraps it back in a functor.
	///
	/// Default Definition:
	///		`fmap(f) • duplicate`
	class func extend(FA -> B) -> FA -> FB
}
