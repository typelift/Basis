//
//  Member.swift
//  Basis
//
//  Created by Robert Widmann on 11/28/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Takes a member function from a class or struct and transforms it into a closure.  To get a value
/// back out of the returned function, apply an instance of the object it was taken from.
///
///     dismember(Array.reverse)([1, 2, 3, 4]) == [1, 2, 3, 4].reverse()
///
/// See ~https://github.com/airspeedswift/SwooshKit for the original.
public func dismember<A, B>(member: A -> () -> B) -> A -> B {
	return { o in member(o)() }
}

public func dismember<A, T, B>(member: A -> T -> B) -> A -> T -> B {
	return { o in { t in member(o)(t) } }
}

public func dismember<A, T, U, B>(member: A -> (T, U) -> B) -> A -> T -> U -> B {
	return { o in { t in { u in member(o)(t, u)} } }
}

public func dismember<A, T, U, V, B>(member: A -> (T, U, V) -> B) -> A -> T -> U -> V -> B {
	return { o in { t in { u in { v in member(o)(t, u, v) } } } }
}
