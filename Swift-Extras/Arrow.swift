//
//  Arrow.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// An Arrow is most famous for being a "Generalization of a Monad".  They're probably better
/// described as a more general view of computation.  Where a monad M<A> yields a value of type A
/// given some context, an Arrow A<B, C> is a function from B -> C in some context A.  Functions are
/// the simplest kind of Arrow (pun intended).  Their context parameter, A, is essentially empty.
/// From there, the B -> C part of the arrow gets alpha-reduced to the A -> B part of the function
/// type.
///
/// Arrows can be modelled with circuit-esque diagrams, and indeed that can often be a better way to
/// envision the various arrow operators.
///
/// - <<<       b -> [ f ] -> c -> [ g ] -> d
/// - >>>       b -> [ f ] -> c -> [ g ] -> d
///
/// - arr       b -> [ f ] -> c
/// - first     b -> [ f ] -> c
///             d ----------> d
///
/// - second    d ----------> d
///             b -> [ f ] -> c
///
/// - ***       b -> [ f ] -> c \
///                               >---> (c, e)
///             d -> [ g ] -> e /
///
///                 /- [ f ] -> c \
/// - &&&       b <                 >---> (c, d)
///                 \- [ g ] -> d /
///
/// Arrows inherit from Category so we can get Composition For Free™.  Unfortunately, we cannot 
/// reuse the typealiases from Category, so you must redefine AB and AC as the source and target 
/// for the Arrow.
public protocol Arrow : Category {
	/// Source
	typealias AB
	/// Target
	typealias AC
	
	/// Some arbitrary target our arrow can compose with.
	typealias D
	/// Some arbitrary target our arrow can compose with.
	typealias E
	
	/// An arrow from A -> B.  Colloquially, the "zero arrow".
	typealias ABC = K2<AB, AC>
	
	/// Type of the result of first().
	typealias FIRST = K2<(AB, D), (AC, D)>
	/// Type of the result of second().
	typealias SECOND = K2<(D, AB), (D, AC)>
	
	/// Some arrow with an arbitrary target and source.  Used in split().
	typealias ADE = K2<D, E>
	/// Type of the result of ***.
	typealias SPLIT = K2<(AB, D), (AC, E)>
	
	/// Some arrow from our target to some other arbitrary target.  Used in fanout().
	typealias ABD = K2<AB, D>
	/// Type of the result of &&&.
	typealias FANOUT = K2<B, (AC, D)>
	
	/// Lift a function to an arrow.
	class func arr(AB -> AC) -> ABC
	
	/// Splits the arrow into two tuples that model a computation that applies our Arrow to an
	/// argument on the "left side" and sends the "right side" through unchanged.
	///
	/// The mirror image of second().
	func first() -> FIRST
	
	/// Splits the arrow into two tuples that model a computation that applies our Arrow to an
	/// argument on the "right side" and sends the "left side" through unchanged.
	///
	/// The mirror image of first().
	func second() -> SECOND
	
	/// Split | Splits two computations and combines the result into one Arrow yielding a tuple of
	/// the result of each side.
	func ***(ABC, ADE) -> SPLIT
	
	/// Fanout | Given two functions with the same source but different targets, this function
	/// splits the computation and combines the result of each Arrow into a tuple of the result of
	/// each side.
	func &&&(ABC, ABD) -> FANOUT
}

public protocol ArrowZero : Arrow {
	class func zeroArrow() -> ABC
}
