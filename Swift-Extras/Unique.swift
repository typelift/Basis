//
//  Unique.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class Unique : K0, Equatable, Hashable {
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

public func ==(lhs: Unique, rhs: Unique) -> Bool {
	return lhs.val == rhs.val
}


//public func newUnique() -> IO<Unique> {
//	return do_({ () -> Unique in		
//		var r : IO<Int> = uniqSource().modifyIORef({ $0 + 1 })
////		return Unique(r)
//	})
//}

private func uniqSource() -> IORef<Int> {
	return newIORef(0).unsafePerformIO()
}


