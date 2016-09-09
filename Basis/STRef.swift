//
//  STRef.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

// Strict mutable references.
public final class STRef<S, A> : K2<S, A> {
	fileprivate var value: A
	
	init(_ val: A) {
		self.value = val
	}
}


// Creates a new STRef
public func newSTRef<S, A>(_ x : A) -> ST<S, STRef<S, A>> {
	return ST<S, STRef<S, A>>(apply: { s in
		let ref = STRef<S, A>(x)
		return (s, ref)
	})
}

// Reads the value of the reference and bundles it in an ST
public func readSTRef<S, A>(_ ref : STRef<S, A>) -> ST<S, A> {
	return .pure(ref.value)
}

// Writes a new value into the reference.
public func writeSTRef<S, A>(_ ref : STRef<S, A>) -> (A) -> ST<S, STRef<S, A>> {
    return { a in 
        return ST(apply: { s in
            ref.value = a
            return (s, ref)
        })
    }
}

// Modifies the reference and returns the updated result.
public func modifySTRef<S, A>(_ ref : STRef<S, A>) -> (@escaping (A) -> A) -> ST<S, STRef<S, A>> {
    return { f in 
        return ST(apply: { s in
            ref.value = f(ref.value)
            return (s, ref)
        })
    }
}

// MARK: Equatable

// Simple reference equality when we've got two objects.
public func ==<S, T : AnyObject>(lhs: STRef<S, T>, rhs: STRef<S, T>) -> Bool {
	return lhs.value === rhs.value
}

public func !=<S, T : AnyObject>(lhs: STRef<S, T>, rhs: STRef<S, T>) -> Bool {
	return !(lhs == rhs)
}
