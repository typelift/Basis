//
//  Bottom.swift
//  Basis
//
//  Created by Robert Widmann on 9/23/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// The type from which no information may be drawn and no instances may be made.  Bottom (also 
/// notated ⊥) is the type of all computations that never complete successfully and is inhabited by
/// infinite loops and fatal errors.
public enum Bottom { }

/// Computes ⊥.
public func absurd() -> Bottom {
	return absurd()
}
