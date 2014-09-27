//
//  Trace.swift
//  Basis
//
//  Created by Robert Widmann on 9/17/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Prints a message before returning a value.
public func trace<A>(msg : String)(e : A) -> A {
	return do_({ () -> IO<A> in
		return putStrLn(msg) >> IO.pure(e)
	}).unsafePerformIO()
}

internal func traceID(msg : String) -> String {
	return trace(msg)(e: msg)
}

/// Prints a printable object before returning a value.
public func tracePrintable<A : Printable, B>(x : A)(e : B) -> B {
	return trace(x.description)(e: e)
}

internal func tracePrintableID<A : Printable>(x : A) -> A {
	return trace(x.description)(e: x)
}

/// Prints out a stack trace before returning a value.
public func traceStack<A>(msg : String)(e : A) -> A {
	return do_ { () -> IO<A> in
		var stack : [String]!
		stack <- currentCallStack()
		if stack.count != 0 {
			return putStrLn(msg + foldr(+)("")(stack)) >> IO.pure(e)
		}
		return putStrLn(msg) >> IO.pure(e)
	}.unsafePerformIO()
}

/// Gets the current call stack symbols.
public func currentCallStack() -> IO<[String]> {
	return IO({ (let rw) in
		return (rw, NSThread.callStackSymbols() as [String])
	})
}


