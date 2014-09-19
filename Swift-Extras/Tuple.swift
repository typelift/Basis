//
//  Tuple.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Extract the first component of a pair.
public func fst<A, B>(t : (A, B)) -> A {
	return t.0
}

/// Extract the second component of a pair
public func snd<A, B>(t : (A, B)) -> B {
	return t.1
}

/// Converts an uncurried function to a curried function.
///
/// A curried function is a function that always returns another function or a value when applied
/// as opposed to an uncurried function which may take tuples.
public func curry<A, B, C>(f : (A, B) -> C) ->  A -> B -> C {
	return { (let a) in
		return { (let b) in
			return f((a, b))
		}
	}
}

/// Converts a curried function to an uncurried function.
///
/// An uncurried function may take tuples as opposed to a curried function which must take a single
/// value and return a single value or function.
public func uncurry<A, B, C>(f : A -> B -> C) -> (A, B) -> C {
	return { (let t) in
		return f(t.0)(t.1)
	}
}

/// Swap the components of a pair.
public func swap<A, B>(t : (A, B)) -> (B, A) {
	return (t.1, t.0)
}

/// Pair Formation | Forms a pair from two arguments.  (⌥ + ⇧ + P)
///
/// (,), the pair formation operator, is a reserved symbol in Swift with a meaning beyond just 
/// tuple formation.  This means it is also not a proper function.  
public func ∏<A, B>(l : A, r : B) -> (A, B) {
	return (l, r)
}
