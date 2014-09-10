//
//  Box.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public final class Box<A> : K1<A> {
	public let unBox : () -> A
	
	init(_ x : A) {
		unBox = { x }
	}
}
