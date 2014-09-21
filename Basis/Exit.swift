//
//  Exit.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public enum ExitCode {
	case ExitSuccess
	case ExitFailure(Int32)
}

/// Exits with a given error code.
public func exitWith<A>(code : ExitCode) -> IO<A> {
	switch code {
		case .ExitSuccess:
			exit(0)
		case .ExitFailure(let n):
			exit(n)
	}
}

/// Exits with failure code 1.
public func exitFailure<A>() -> IO<A> {
	return exitWith(.ExitFailure(1))
}

/// Exits with error code 0 (success).
public func exitSuccess<A>() -> IO<A> {
	return exitWith(.ExitSuccess)
}
