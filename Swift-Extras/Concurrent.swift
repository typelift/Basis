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

public func forkIO(io : IO<()>) -> IO<ThreadID> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.forkWithStart({
			return io.unsafePerformIO()
		}))
	})
}

public func getNumProcessors() -> IO<UInt> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.CPUCount())
	})
}

public func killThread(tid : ThreadID) -> IO<()> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.killThread(tid))
	})
}

public func yield() -> IO<()> {
	return IO({ (let rw) in
		return (rw, CFIRealWorld.yieldThread())
	})
}

public func labelThread(name : String) -> IO<()> {
	return IO({ (let rw) in
		return (rw, name.withCString({ (let str) -> Void in
			return CFIRealWorld.labelThreadWithName(str)
		}))
	})
}
