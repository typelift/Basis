//
//  Unique.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Abstract Unique objects.  Objects of type Unique may be compared for equality and ordering and 
/// hashed.
public class Unique : K0, Equatable, Hashable, Comparable {
	private class var source : IORef<Int> {
		return innerSource
	}
	
	private let val : Int
	
	public var hashValue: Int { 
		get {
			return self.val
		}
	}
	
	public init(_ x : Int) {
		self.val = x
	}
}

/// Creates a new object of type Unique.  The value returned will not compare equal to any other 
/// value of type Unique returned by previous calls to newUnique. There is no limit on the number of
/// times newUnique may be called.
public func newUnique() -> IO<Unique> {
	return do_({ () -> Unique in		
		var r : Int!
		
		r <- modifyIORef(Unique.source)({ $0 + 1 }) >> readIORef(Unique.source)
		return Unique(r)
	})
}

public func <=(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val <= rhs.val
}

public func >=(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val >= rhs.val
}

public func >(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val > rhs.val
}

public func <(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val < rhs.val
}

public func ==(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val == rhs.val
}

private let innerSource : IORef<Int> = {
	var ref : IORef<Int>!
	ref <- newIORef(0)
	return ref
}()
