//
//  Error.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/11/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Immediately terminates the program with an error message.
public func error<A>(x : StaticString) -> A {
	assert(false, x)
}

/// A special case of error.
///
/// Undefined is often used in place of an actual definition for functions that have yet to be
/// written.  When the compiler calls said function, it will immediately terminate the program until
/// a suitable definition is put in its place.
///
/// For example:
///
///     public func sortBy<A>(cmp : (A, A) -> Bool)(lst : [A]) -> [A] {
///         return undefined()
///     }
public func undefined<A>() -> A {
	return error("Undefined")
}

