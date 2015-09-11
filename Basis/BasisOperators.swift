//
//  Operators.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// MARK: Data.Combinator

/// Pair Formation | Forms a pair from two arguments.  (⌥ + ⇧ + P)
infix operator ∏ {}

/// Cons | Constructs a list by appending a given element to the front of a list.
infix operator <<| {
	precedence 0
	associativity right
}

/// Snoc | Constructs a list by appending a given element to the end of a list.
infix operator |>> {
	precedence 0
	associativity left
}

/// As Type Of | A type-restricted version of const.  In cases of typing ambiguity, using this 
/// function forces its first argument to resolve to the type of the second argument.  
///
/// Composed because it is the face one makes when having to tell the typechecker how to do its job.
infix operator >-< {
	precedence 100
	associativity left
}

/// MARK: Data.Functor

/// Replace | Maps all the values "inside" one functor to a user-specified constant.
infix operator <% {
	precedence 140
	associativity left
}

/// Replace Backwards | Maps all the values "inside" one functor to a user-specified constant.
infix operator %> {
	precedence 140
	associativity left
}

/// MARK: Data.Functor.Contravariant

/// Contramap | Maps all values "inside" one functor contravariantly.
infix operator >%< {
	precedence 140
	associativity left
}

/// Replace | Maps all points to a specified constant contravariantly.
infix operator >% {
	precedence 140
	associativity left
}

/// MARK: Control.Applicative

/// Choose | Makes Applicative a monoid.
infix operator <|> {
	precedence 130
	associativity left
}

/// MARK: System.IO

/// Extract | Extracts a value from a monadic computation.
prefix operator ! {}

/// MARK: Control.Comonad.Apply

/// Ap | Promotes function application.
infix operator >*< {
	precedence 140
	associativity left
}

/// Sequence Right | Disregards the Functor on the Left.
infix operator *< {
	precedence 140
	associativity left
}

/// Sequence Left | Disregards the Functor on the Right.
infix operator >* {
	precedence 140
	associativity left
}

/// Lift | Lifts a function to an Arrow.
prefix operator ^ {}

/// Lower | Lowers an arrow to a function.
postfix operator ^ {}
