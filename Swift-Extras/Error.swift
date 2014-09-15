//
//  Error.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/11/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// 
public func error<A>(x : StaticString) -> A {
	assert(false, x)
}

public func undefined<A>() -> A {
	return error("Undefined")
}

