//
//  Exception.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Exception : Printable {	}

public struct SomeException : Exception {
	public var description : String
	
	init(_ desc : String) {
		self.description = desc
	}
}

public func throw<A, E : Exception>(e : E) -> A {
	CFIExceptionImpl.raise(e.description)
	assert(false, "")
}


public func throwIO<A, E : Exception>(e : E) -> IO<A> {
	CFIExceptionImpl.raise(e.description)
	assert(false, "")
}

public func catchException<A>(io : IO<A>)(handler: Exception -> IO<A>) -> IO<A> {
	return catch(io)({ (let excn : NSException!) in
		return handler(SomeException(excn.description ?? ""))
	})
}


public func mask<A, B>(io : (IO<A> -> IO<A>) -> IO<B>) -> IO<B> {
	return io(id)
}

// Crashing the compiler again... Sigh
//public func onException<A, B>(io : IO<A>)(what : IO<B>) -> IO<A> {
//	return catchException(io)({ (let e) in
//		return do_({
//			var b : B!
//			
//			b <- what
//			return throwIO(e)
//		})
//	})
//}
//
//public func bracket<A, B, C>(before : IO<A>)(after : A -> IO<B>)(thing : A -> IO<C>) -> IO<C> {
//	return mask({ (let restore) in
//		return do_ { () -> C in
//			var a : A!
//			var r : C!
//			var b : B!
//			
//			a <- before
//			r <- onException(restore(thing(a)))(after(a))
//			b <- after(a)
//			return r
//		}	
//	})
//}

private func catch<A>(io : IO<A>)(h : (NSException! -> IO<A>)) -> IO<A> {
	var val : A! 
	CFIExceptionImpl.catch({ val = io.unsafePerformIO() }, to: { val = h($0).unsafePerformIO() })
	return IO.pure(val!)
}


