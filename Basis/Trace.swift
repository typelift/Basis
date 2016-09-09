//
//  Trace.swift
//  Basis
//
//  Created by Robert Widmann on 9/17/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import class Foundation.Thread

/// Prints a message before returning a value.
public func trace<A>(_ msg : String) -> (A) -> A {
    return { e in 
        return do_({ () -> IO<A> in
            return putStrLn(msg) >> IO.pure(e)
        }).unsafePerformIO()
    }
}

internal func traceID(_ msg : String) -> String {
	return trace(msg)(msg)
}

/// Prints a printable object before returning a value.
public func tracePrintable<A : CustomStringConvertible, B>(_ x : A) -> (B) -> B {
	return trace(x.description)
}

internal func tracePrintableID<A : CustomStringConvertible>(_ x : A) -> A {
	return trace(x.description)(x)
}

/// Prints out a stack trace before returning a value.
public func traceStack<A>(_ msg : String) -> (A) -> A {
    return { e in 
        return do_ { () -> IO<A> in
            let stack : [String] = !currentCallStack()
            if stack.count != 0 {
                return putStrLn(msg + foldr(+)("")(stack)) >> IO.pure(e)
            }
            return putStrLn(msg) >> IO.pure(e)
        }.unsafePerformIO()
    }
}

/// Gets the current call stack symbols.
public func currentCallStack() -> IO<[String]> {
	return IO { rw in
		return (rw, Thread.callStackSymbols)
	}
}

import class Foundation.NSThread
