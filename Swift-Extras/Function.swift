//
//  Function.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class Function1<A, B> : K2<A, B> {
	let ap : A -> B
	public init(_ apply : A -> B) {
		self.ap = apply
	}
	
	public func apply(x : A) -> B {
		return self.ap(x)
	}
}

public class Function2<A, B, C> : K3<A, B, C> {
	let ap : (A, B) -> C
	public init(_ apply : (A, B) -> C) {
		self.ap = apply
	}
	
	public func apply(x : A, y : B) -> C {
		return self.ap(x, y)
	}
}


