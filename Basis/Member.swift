//
//  Member.swift
//  Basis
//
//  Created by Robert Widmann on 11/28/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
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