//
//  Copointed.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Copointed sits in the middle distance between a Functor and a Comonad.  It is a functor equipped
/// with a copoint that extracts a value from the functor.
public protocol Copointed : Functor {	
	/// Lifts a value from the Functor.
	func extract() -> A
}
