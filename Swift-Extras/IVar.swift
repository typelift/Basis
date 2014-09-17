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
	private let val : A
	
	init(_ lock : MVar<()>, _ trans : MVar<A>, _ val : A) {
		self.lock = lock
		self.trans = trans
		self.val = val
	}
}

public func newEmptyIVar<A>() -> IO<IVar<A>> {
	return do_ { () -> IVar<A> in
		var lock : MVar<()>!
		var trans : MVar<A>!
		var val : A!
		
		lock <- newMVar(())
		trans <- newEmptyMVar()
		val <- takeMVar(trans)
		return IVar(lock, trans, val)
	}
}

public func newIVar<A>(x : A) -> IO<IVar<A>> {
	return do_ { () -> IVar<A> in
		var lock : MVar<()>!
		return IVar(lock, error("unused MVar"), x)
	}
}

public func readIVar<A>(v : IVar<A>) -> A {
	return v.val
}

public func tryReadIVar<A>(v : IVar<A>) -> IO<Optional<A>> {
	return do_ { () -> Optional<A> in
		var empty : Bool!
		
		empty <- isEmptyMVar(v.lock)
		if empty! {
			return .Some(v.val)
		}
		return .None
	}
}

public func writeIVar<A>(v : IVar<A>)(x : A) -> IO<()> {
	return do_ { () -> IO<()> in
		var a : Bool!
		
		a <- tryWriteIVar(v)(x: x)
		if a! == false {
			return throwIO(BlockedIndefinitelyOnIVar())
		}
		return IO.pure(())
	}
}

public func tryWriteIVar<A>(v : IVar<A>)(x : A) -> IO<Bool> {
	return do_ { () -> IO<Bool> in
		var a : Optional<()>!
		
		a <- tryTakeMVar(v.lock)
		switch a! {
			case .None:
				return IO.pure(false)
			case .Some(_):
				return putMVar(v.trans)(x: v.val) >> IO.pure(true)
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

