//
//  Exit.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public enum ExitCode {
	case ExitSuccess
	case ExitFailure(Int32)
}

public func exitWith<A>(code : ExitCode) -> IO<A> {
	switch code {
		case .ExitSuccess:
			exit(0)
		case .ExitFailure(let n):
			exit(n)
	}
}

public func exitFailure<A>() -> IO<A> {
	return exitWith(.ExitFailure(1))
}

public func exitSuccess<A>() -> IO<A> {
	return exitWith(.ExitSuccess)
}
