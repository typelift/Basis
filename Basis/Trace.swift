//
//  Trace.swift
//  Basis
//
//  Created by Robert Widmann on 9/17/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func trace<A>(msg : String)(e : A) -> A {
	return do_({ () -> IO<A> in
		return putStrLn(msg) >> IO.pure(e)
	}).unsafePerformIO()
}

public func traceID(msg : String) -> String {
	return trace(msg)(e: msg)
}

public func tracePrintable<A : Printable, B>(x : A)(e : B) -> B {
	return trace(x.description)(e: e)
}

public func tracePrintableID<A : Printable>(x : A) -> A {
	return trace(x.description)(e: x)
}

public func traceStack<A>(msg : String)(e : A) -> A {
	return do_ { () -> IO<A> in
		var stack : [String]!
		stack <- currentCallStack()
		if stack.count != 0 {
			return putStrLn(msg + foldr(+)(z: "")(l: stack)) >> IO.pure(e)
		}
		return putStrLn(msg) >> IO.pure(e)
	}.unsafePerformIO()
}

public func currentCallStack() -> IO<[String]> {
	return IO({ (let rw) in
		return (rw, NSThread.callStackSymbols() as [String])
	})
}


