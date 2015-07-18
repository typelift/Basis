//
//  Pointed.swift
//  Basis
//
//  Created by Robert Widmann on 12/12/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// A pointed type is any type that can take an element of its underlying type and create an
/// instance of itself containing elements of that type.
public protocol Pointed {
	typealias A
	static func pure(_: A) -> Self
}
