//
//  Applicative.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Applicative sits in the middle distance between a Functor and a Monad.  
///
/// Applicative Functors, as the name implies, allow for the application of functions inside of
/// Functors.  In this way Applicative Functors provide the  ability to operate on not just values, 
/// but values in a functorial context such as Eithers, Lists, and Optionals without needing to 
/// unwrap or map over their contents.
public protocol Applicative : Pointed, Functor {
	/// Type of Functors containing morphisms from our objects to a target.
	associatedtype FAB = K1<(A) -> B>
	
	static func ap(_: FAB) -> (Self) -> FB
	
	/// Sequential Application | Applies the function "inside the Functor" to the "inside" of our 
	/// Functor and herds up the results.
	static func <*>(_: FAB , _: Self) -> FB
	
	/// Sequence Right | Executes the action in the functor on the left and returns the functor on
	/// the right.
	///
	/// Default definition: 
	///
	///		const(id) <^> a <*> b
	static func *>(_: Self, _: FB) -> FB
	
	/// Sequence Left | Disregards the Functor on the Right.
	///
	/// Default definition: 
	///
	///		const <^> a <*> b
	static func <*(_: Self, _: FB) -> Self
}

/// Alternatives are Applicative Monoids.
public protocol Alternative : Applicative {
	/// The type of the result of Alternative's mappend-esque functions.
	associatedtype FLA = K1<[A]>
	associatedtype FMA = K1<Optional<A>>

	/// Returns the identity element.
	func empty() -> Self
	
	/// Choose | Chooses the greater of two Alternatives.
	///
	/// This function will attempt to choose an Alternative that is not the empty() Alternative.
	static func <|>(_: Self, _: Self) -> Self

	/// One or more
	///
	/// The least solution to the equation:
	///
	///		curry(<|) <^> v <*> many(v)
	func some(_: Self) -> FLA

	/// Zero or more
	///
	/// The least solution to the equation:
	///
	///		some(v) <|> pure([])
	func many(_: Self) -> FLA
	
	/// One or none
	///
	/// Default definition:
	///
	///		`Optional.just <^> v <|> pure(Optional.None)`
	func optional(_: Self) -> FMA
}

/// Additional functions to be implemented by those types conforming to the Applicative protocol.
public protocol ApplicativeOps : Applicative {
	associatedtype C
	associatedtype FC = K1<C>
	associatedtype D
	associatedtype FD = K1<D>

	/// Lift a function to a Functorial action.
	static func liftA(_ f : @escaping (A) -> B) -> (Self) -> FB

	/// Lift a binary function to a Functorial action.
	static func liftA2(_ f : @escaping (A) -> (B) -> C) -> (Self) -> (FB) -> FC

	/// Lift a ternary function to a Functorial action.
	static func liftA3(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Self) -> (FB) -> (FC) -> FD
}
