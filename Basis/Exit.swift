//
//  Exit.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public enum ExitCode {
	case exitSuccess
	case exitFailure(Int32)
}

/// Exits with a given error code.
public func exitWith<A>(_ code : ExitCode) -> IO<A> {
	switch code {
		case .exitSuccess:
			exit(0)
		case .exitFailure(let n):
			exit(n)
	}
}

/// Exits with failure code 1.
public func exitFailure<A>() -> IO<A> {
	return exitWith(.exitFailure(1))
}

/// Exits with error code 0 (success).
public func exitSuccess<A>() -> IO<A> {
	return exitWith(.exitSuccess)
}

import func Darwin.exit
