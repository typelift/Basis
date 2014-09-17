//
//  TVar.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//


private struct TID : Hashable {
	let magic : Int = 0
	let threadID : ThreadID
	let localID : Int = 0
	
	var hashValue: Int { 
		get {
			return magic * (unsafeCoerce(threadID.memory) as Int) * localID
		}
	}
}


private func ==(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

private struct TVID : Hashable {
	let tid : TID
	var direct : [TVID]
	
	var hashValue: Int { 
		get {
			return tid.hashValue
		}
	}
}

private func ==(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid == rhs.tid
}

private struct TVarRep {
	let version : Int
	let record : String
}

private struct LogItem {
	let preVersion : String?
	let newValue : AnyObject?
}

private struct ThreadState {
	var environment : Environment
	var log : Log
	var tidCount : Int
	var layer : Int
}

private struct ThreadInfo {
	let channel : Chan<()>
	let waitTID : [TID]
	let state : ThreadState
}

private typealias Environment = Map<TID, TVarRep>
private typealias Log = Map<TVID, LogItem>
private typealias ThreadTable = Map<ThreadID, ThreadInfo>

private func globalEnvironment() -> IORef<Environment> {
	var ref : IORef<Environment>!
	ref <- newIORef(empty())
	return ref
}

private func globalThreadInfo() -> IORef<ThreadTable> {
	var ref : IORef<ThreadTable>!
	ref <- newIORef(empty())
	return ref
}

private func newThread() -> IO<ThreadInfo> {
	return do_ { () -> ThreadInfo in
		let thrID = pthread_self()
		
		var chan : Chan<()>!
		var env : Environment!
		
		chan <- newChan()
		env <- readIORef(globalEnvironment())
		
		return ThreadInfo(channel: chan, waitTID: [], state: ThreadState(environment: env, log: empty(), tidCount: 0, layer: 0))
	}
}

public final class TVar<A> : K1<A> {
	private var val : (World<RealWorld>, A)
	
	init(_ val : (World<RealWorld>, A)) {
		self.val = val
	}
}



