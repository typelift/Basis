//
//  Optional.swift
//  Basis
//
//  Created by Robert Widmann on 10/4/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Takes a default value, a function, and an optional.  If the optional is None, the default value
/// is returned.  If the optional is Some, the function is applied to the value inside.
public func maybe<A, B>(def : B)(f : A -> B)(m : Optional<A>) -> B {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return f(x)
	}
}

/// Returns whether a given optional contains a value.
public func isSome<A>(o : Optional<A>) -> Bool {
	switch o {
		case .None:
			return false
		default:
			return true
	}
}

/// Returns whether a given optional is empty.
public func isNone<A>(o : Optional<A>) -> Bool {
	switch o {
		case .None:
			return true
		default:
			return false
	}
}

/// Returns the value from an Optional.
///
/// If the given optional is None, this function throws an exception.
public func fromSome<A>(m : Optional<A>) -> A {
	switch m {
		case .None:
			return error("Cannot extract value from None")
		case .Some(let x):
			return x
	}
}

/// Takes a default value and an optional.  If the optional is empty, the default value is returned.
/// If the optional contains a value, that value is returned.
///
/// This function is a safer form of !-unwrapping for optionals.
public func fromOptional<A>(def : A)(m : Optional<A>) -> A {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return x
	}
}

/// Given an optional, returns an empty list if it is None, or a singleton list containing the
/// contents of a Some.
public func optionalToList<A>(o : Optional<A>) -> [A] {
	switch o {
		case .None:
			return []
		case .Some(let x):
			return [x]
	}
}

/// Given a list, returns None if the list is empty, or Some containing the head of the list.
public func listToOptional<A>(l : [A]) -> Optional<A> {
	switch destruct(l) {
		case .Empty:
			return .None
		case .Cons(let x, _):
			return .Some(x)
	}
}

/// Takes a list of optionals and returns a list of all the values of the Some's in the list.
public func catOptionals<A>(l : [Optional<A>]) -> [A] {
	return concatMap(optionalToList)(l)
}

/// Maps a function over a list.  If the result of the function is None, the value is not included
/// in the resulting list.
public func mapOptional<A, B>(f : A -> Optional<B>)(l : [A]) -> [B] {
	switch destruct(l) {
		case .Empty:
			return []
		case .Cons(let x, let xs):
			let rs = mapOptional(f)(l: xs)
			switch f(x) {
				case .None:
					return rs
				case .Some(let r):
					return r <| rs
			}
	}
}

