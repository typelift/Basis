//
//  IVar.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// IVars are write-once mutable references.  Attempting to write into an already full IVar throws
/// an exception because the thread will be blocked indefinitely.
public final class IVar<A> : K1<A> {
	private let lock : MVar<()>
	private let trans : MVar<A>
	private let val : IO<A>
	
	init(_ lock : MVar<()>, _ trans : MVar<A>, _ val : IO<A>) {
		self.lock = lock
		self.trans = trans
		self.val = val
	}
}

/// Creates a new empty IVar
public func newEmptyIVar<A>() -> IO<IVar<A>> {
	return do_ { () -> IVar<A> in
		var lock : MVar<()>!
		var trans : MVar<A>!
		
		lock <- newMVar(())
		trans <- newEmptyMVar()
		return IVar(lock, trans, do_ { () -> A in
			var val : A!
			val <- takeMVar(trans)
			return val
		})
	}
}

/// Creates a new IVar containing the supplied value.
public func newIVar<A>(x : A) -> IO<IVar<A>> {
	return do_ { () -> IVar<A> in
		var lock : MVar<()>!
		return IVar(lock, error("unused MVar"), IO.pure(x))
	}
}

/// Returns the contents of the IVar.
///
/// If the IVar is empty, this will block until a value is put into the IVar.  If the IVar is full,
/// the function returns the value immediately.
public func readIVar<A>(v : IVar<A>) -> A {
	var val : A!
	val <- v.val
	return val
}

/// Writes a value into an IVar.
///
/// If the IVar is currently full, the calling thread will seize up, and this function will throw an
/// exception.
public func putIVar<A>(v : IVar<A>)(x : A) -> IO<()> {
	return do_ { () -> IO<()> in
		var a : Bool!
		
		a <- tryPutIVar(v)(x: x)
		if a! == false {
			return throwIO(BlockedIndefinitelyOnIVar())
		}
		return IO.pure(())
	}
}

/// Attempts to read the contents of an IVar
///
/// If the MVar is empty, this function returns a None in an IO computation.  If the MVar is full,
/// this function wraps the value in a Some and an IO computation and returns immediately.
public func tryReadIVar<A>(v : IVar<A>) -> IO<Optional<A>> {
	return do_ { () -> Optional<A> in
		var empty : Bool!
		
		empty <- isEmptyMVar(v.lock)
		if empty! {
			var val : A!
			val <- v.val
			return .Some(val)
		}
		return .None
	}
}

/// Attempts to write a vlaue into an IVar.
///
/// If the IVar is empty, this will immediately return true wrapped in an IO computation.  If the
/// IVar is full, nothing happens and it will return false wrapped in an IO computation.
public func tryPutIVar<A>(v : IVar<A>)(x : A) -> IO<Bool> {
	return do_ { () -> IO<Bool> in
		var a : Optional<()>!
		
		a <- tryTakeMVar(v.lock)
		switch a! {
			case .None:
				return IO.pure(false)
			case .Some(_):
				var val : A!
				val <- v.val
				return putMVar(v.trans)(x: val) >> IO.pure(true)
		}
	}
}

public struct BlockedIndefinitelyOnIVar : Exception {
	public var description: String { 
		get {
			return "Cannot write to an already full IVar.  Thread blocked indefinitely."
		}
	}
}

