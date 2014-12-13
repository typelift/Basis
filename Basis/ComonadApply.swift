//
//  ComonadApply.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Foundation

/// Comonads along with the structure of Applicative Functors.
public protocol ComonadApply : Comonad {
	/// Type of Functors containing morphisms from our objects to a target.
	typealias FAB = K1<A -> B>
	
	func >*<(FAB , Self) -> FB
	
	/// Sequence Right | Executes the action in the functor on the left and returns the functor on
	/// the right.
	///
	/// Default definition: 
	///		`const(id) <%> a >*< b`
	func *<(Self, FB) -> FB
	
	/// Sequence Left | Disregards the Functor on the Right.
	///
	/// Default definition: 
	///		`const <%> a >*< b`
	func >*(Self, FB) -> Self
}
