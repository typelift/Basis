//
//  Copointed.swift
//  Basis
//
//  Created by Robert Widmann on 11/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public protocol Copointed {	
	typealias A
	func extract() -> A
}
