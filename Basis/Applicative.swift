//
//  Applicative.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Applicative sits in the middle distance between a Functor and a Monad.  While you do not get
/// >>- yet, there is more than enough power in the generality of the interface to make up for it.
public protocol Applicative : Functor {
	/// Type of Functors containing morphisms from our objects to a Target.
	typealias FAB = K1<A -> B>
	
	/// Lifts a value into the Functor.
	class func pure(A) -> FA
	
	/// Sequential Application | Applies the function "inside the Functor" to the "inside" of our 
	/// Functor and herds up the results.
	func <*>(FAB , Self) -> FB
	
	/// Sequence Right | Disregards the Functor on the Left.
	///
	/// Default definition: 
	///		`const(id) <%> a <*> b`
	func *>(Self, FB) -> FB
	
	/// Sequence Left | Disregards the Functor on the Right.
	///
	/// Default definition: 
	///		`const <%> a <*> b`
	func <*(Self, FB) -> FA
}

/// Alternatives are Applicative Monoids.
public protocol Alternative : Applicative {
	/// The type of the result of Alternative's mappend-esque functions.
	typealias FLA = K1<[A]>
	
	/// Returns the identity element.
	func empty() -> FA
	
	/// Choose | Chooses the greater of two Alternatives.
	///
	/// This function will attempt to choose an Alternative that is not the empty() Alternative.
	func <|>(FA, FA) -> FA

	/// One or more
	///
	/// The least solution to the equation:
	///
	///		curry((+>)) <%> v <*> many(v)
	func some(FA) -> FLA

	/// Zero or more
	///
	/// The least solution to the equation:
	///
	///		some(v) <|> FLA.pure([])
	func many(FA) -> FLA
}
