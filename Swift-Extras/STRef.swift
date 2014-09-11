//
//  STRef.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

// Strict mutable references.
public final class STRef<S, A> : K2<S, A> {
	private var value: A
	
	init(_ val: A) {
		self.value = val
	}
	
	// Reads the value of the reference and bundles it in an ST
	public func readSTRef() -> ST<S, A> {
		return .pure(self.value)
	}
	
	// Writes a new value into the reference.
	public func writeSTRef(a: A) -> ST<S, STRef<S, A>> {
		return ST(apply: { (let s) in
			self.value = a
			return (s, self)
		})
	}
	
	// Modifies the reference and returns the updated result.
	public func modifySTRef(f: A -> A) -> ST<S, STRef<S, A>> {
		return ST(apply: { (let s) in
			self.value = f(self.value)
			return (s, self)
		})
	}
}

// Creates a new STRef
public func newSTRef<S, A>(x : A) -> ST<S, STRef<S, A>> {
	return ST(apply: { (let s) in
		let ref = STRef<S, A>(x)
		return (s, ref)
	})
}

public func ==<S, A : Equatable>(lhs : STRef<S, A>, rhs : STRef<S, A>) -> Bool {
	return (lhs.value == rhs.value)
}
