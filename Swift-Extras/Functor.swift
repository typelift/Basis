//
//  Functor.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Functors map the functions and objects in one set to a different set of functions and objects.
/// This is represented by any structure parametrized by some set A, and a function `fmap` that 
/// takes objects in A to objects in B and wraps the result back in a functor.  `fmap` respects the
/// following commutative diagram:
///
///
///        F(A)
///         •
///         |\
///         | \
///         |  \
///         |   \
/// fmap f  |    \  fmap (f • g)
///         |     \
///         |      \
///         |       \
///         •--------•
///       F(B)       F(C)
///            fmap g
///
/// Formally, a Functor is a mapping between Categories, but we have to restrict ourselves to the
/// Category of Swift Types (S), so in practice a Functor is just an Endofunctor.  Functors are
/// often described as "Things that can be mapped over".
public protocol Functor {
	/// Type of Source Objects
	typealias A
	/// Type of Target Objects
	typealias B
	
	/// Type of our Functor
	typealias FA = K1<A>
	
	/// Type of a target Functor
	typealias FB = K1<B>
	
	/// Map "inside" a Functor.
	///
	/// F on our diagram.
	class func fmap(A -> B) -> FA -> FB
	func <%>(A -> B, FA) -> FB

	/// Constant Replace | Replaces all values in the target Functor with a singular constant value
	/// from the source Functor.
	func <^(A, FB) -> FA
}

/// Eases writing a definition for Constant Replace.  Hand it an fmap, and x in B, and a source.
public func defaultReplace<A, B, FA : Functor, FB : Functor>(fmap : (A -> B) -> FA -> FB)(x : B)(f : FA) -> FB {
	return (fmap • const)(x)(f)
}

