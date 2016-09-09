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
public func optional<A, B>(_ def : B) -> ((A) -> B) -> (Optional<A>) -> B {
    return { f in { m in
        switch m {
        case .none:
            return def
        case .some(let x):
            return f(x)
        }
    } }
}

/// Returns whether a given optional contains a value.
public func isSome<A>(_ o : Optional<A>) -> Bool {
	switch o {
		case .none:
			return false
		default:
			return true
	}
}

/// Returns whether a given optional is empty.
public func isNone<A>(_ o : Optional<A>) -> Bool {
	switch o {
		case .none:
			return true
		default:
			return false
	}
}

/// Returns the value from an Optional.
///
/// If the given optional is None, this function throws an exception.
public func fromSome<A>(_ m : Optional<A>) -> A {
	switch m {
		case .none:
			return error("Cannot extract value from None")
		case .some(let x):
			return x
	}
}

/// Takes a default value and an optional.  If the optional is empty, the default value is returned.
/// If the optional contains a value, that value is returned.
///
/// This function is a safer form of !-unwrapping for optionals.
public func fromOptional<A>(_ def : A) -> (Optional<A>) -> A {
    return { m in
        switch m {
        case .none:
            return def
        case .some(let x):
            return x
        }   
    }
}

/// Given an optional, returns an empty list if it is None, or a singleton list containing the
/// contents of a Some.
public func optionalToList<A>(_ o : Optional<A>) -> [A] {
	switch o {
		case .none:
			return []
		case .some(let x):
			return [x]
	}
}

/// Given a list, returns None if the list is empty, or Some containing the head of the list.
public func listToOptional<A>(_ l : [A]) -> Optional<A> {
	switch match(l) {
		case .nil:
			return .none
		case .cons(let x, _):
			return .some(x)
	}
}

/// Takes a list of optionals and returns a list of all the values of the Some's in the list.
public func catOptionals<A>(_ l : [Optional<A>]) -> [A] {
	return concatMap(optionalToList)(l)
}

/// Maps a function over a list.  If the result of the function is None, the value is not included
/// in the resulting list.
public func mapOptional<A, B>(_ f : @escaping (A) -> Optional<B>) -> ([A]) -> [B] {
    return { l in
        switch match(l) {
        case .nil:
            return []
        case .cons(let x, let xs):
            let rs = mapOptional(f)(xs)
            switch f(x) {
            case .none:
                return rs
            case .some(let r):
                return r <<| rs
            }
        }   
    }
}

