//
//  Pointed.swift
//  Basis
//
//  Created by Robert Widmann on 12/12/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

public protocol Pointed {
	typealias A
	class func pure(A) -> Self
}