//
//  Pointed.swift
//  Basis
//
//  Created by Robert Widmann on 12/12/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public protocol Pointed {
	typealias A
	static func pure(A) -> Self
}
