//
//  Concurrent.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/15/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public typealias ThreadID = pthread_t

public func myTheadID() -> IO<ThreadID> {
	return IO.pure(pthread_self())
}

/// Forks a computation onto a new thread and returns its thread ID.
public func forkIO(io : IO<()>) -> IO<ThreadID> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.forkWithStart({
			return io.unsafePerformIO()
		}))
	})
}

/// Returns the number of processor the host has.
public func getNumProcessors() -> IO<UInt> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.CPUCount())
	})
}

/// Kills a given thread.
///
/// This function invokes pthread_kill, so all necessary cleanup handlers will fire.  Threads may
/// not immediately terminate if they are setup improperly or by the user.
public func killThread(tid : ThreadID) -> IO<()> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.killThread(tid))
	})
}

/// Indicates that a thread wishes to yeild time to other waiting threads.
public func yield() -> IO<()> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.yieldThread())
	})
}

/// Labels the current thread.
public func labelThread(name : String) -> IO<()> {
	return IO({ (let rw) in
		return (rw, name.withCString({ (let str) -> Void in
			return CFIRealWorld.labelThreadWithName(str)
		}))
	})
}
