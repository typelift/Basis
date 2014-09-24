//
//  Arrow.swift
//  Basis
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
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
///
/// - first     b -> [ f ] -> c
///             d - - - - -> d
///
/// - second    d - - - - -> d
///             b -> [ f ] -> c
///
///
/// - ***       b - [ f ] -> c - •
///                               \
///                                o - -> (c, e)
///                               /
///             d - [ g ] -> e - •
///
///
///                 • - [ f ] -> c - •
///                 |                 \
/// - &&&       b - o                  o - -> (c, d)
///                 |                 /
///                 • - [ g ] -> d - •
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

/// Arrows that can produce an identity arrow.
public protocol ArrowZero : Arrow {
	/// The identity arrow.
	class func zeroArrow() -> ABC
}

/// A monoid for Arrows.
public protocol ArrowPlus : ArrowZero {
	/// A binary function that combines two arrows.
	func <+>(ABC, ABC) -> ABC
}

public protocol ArrowChoice : Arrow {
	/// The result of left
	typealias LEFT = K2<Either<AB, D>, Either<AC, D>>
	/// The result of right
	typealias RIGHT = K2<Either<D, AB>, Either<D, AC>>

	/// The result of +++
	typealias SPLAT = K2<Either<AB, D>, Either<AC, E>>

	/// Some arrow from a different source and target for fanin.
	typealias ACD = K2<AC, D>
	/// The result of |||
	typealias FANIN = K2<Either<AB, AC>, D>

	/// Feed marked inputs through the argument arrow, passing the rest through unchanged to the 
	/// output.
	func left(ABC) -> LEFT
	
	/// The mirror image of left.
	func right(ABC) -> RIGHT

	/// Splat | Split the input between both argument arrows, then retag and merge their outputs 
	/// into Eithers.
	func +++(ABC, ADE) -> SPLAT
	
	/// Fanin | Split the input between two argument arrows and merge their ouputs.
	func |||(ABD, ACD) -> FANIN
}

/// Arrows that allow application of arrow inputs to other inputs.
public protocol ArrowApply : Arrow {
	typealias APP = K2<(ABC, AB), AC>
	func app() -> APP
}

/// Arrows that admit right-tightening recursion.
public protocol ArrowLoop : Arrow {
	typealias LOOP = K2<(AB, D), (AC, D)>
	
	func loop(LOOP) -> ABC
}
