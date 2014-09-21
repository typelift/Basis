//
//  TVar.swift
//  Basis
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//


internal struct TID : Hashable, Comparable {
	let magic : Int = 0
	let threadID : ThreadID
	let localID : Int = 0
	
	var hashValue: Int { 
		get {
			return magic * (unsafeCoerce(threadID.memory) as Int) * localID
		}
	}
}


internal func ==(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

internal func <=(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue <= rhs.hashValue
}

internal func >=(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue >= rhs.hashValue
}

internal func >(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue > rhs.hashValue
}

internal func <(lhs: TID, rhs: TID) -> Bool {
	return lhs.hashValue < rhs.hashValue
}

internal struct TVID : Hashable, Comparable {
	let tid : TID
	var direct : [TVID]
	
	var hashValue: Int { 
		get {
			return tid.hashValue
		}
	}
}

internal func ==(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid == rhs.tid
}

internal func <=(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid <= rhs.tid
}

internal func >=(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid >= rhs.tid
}

internal func >(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid > rhs.tid
}

internal func <(lhs: TVID, rhs: TVID) -> Bool {
	return lhs.tid < rhs.tid
}

internal struct TVarRep {
	let version : Int
	let record : String
}

internal struct LogItem<A> {
	let preVersion : String?
	let newValue : A?
}

internal struct ThreadState<A> {
	var environment : Environment
	var log : Map<TVID, LogItem<A>>
	var tidCount : Int
	var layer : Int
}

internal struct ThreadInfo<A> {
	let channel : Chan<()>
	let waitTID : [TID]
	let state : ThreadState<A>
}

internal typealias Environment = Map<TID, TVarRep>

internal func globalEnvironment() -> IORef<Environment> {
	var ref : IORef<Environment>!
	ref <- newIORef(empty())
	return ref
}

internal func globalThreadInfo<A>() -> IORef<Map<ThreadID, ThreadInfo<A>>> {
	var ref : IORef<Map<ThreadID, ThreadInfo<A>>>!
	ref <- newIORef(empty())
	return ref
}

internal func newThread<A>() -> IO<ThreadInfo<A>> {
	return do_ { () -> ThreadInfo<A> in
		let thrID = pthread_self()
		
		var chan : Chan<()>!
		var env : Environment!
		
		chan <- newChan()
		env <- readIORef(globalEnvironment())
		
		return ThreadInfo(channel: chan, waitTID: [], state: ThreadState(environment: env, log: empty(), tidCount: 0, layer: 0))
	}
}

public final class TVar<A> : K1<A> {
	internal var val : ThreadState<A> -> (ThreadState<A>, A)
	internal let tvid : TVID
	
	internal init(_ val : ThreadState<A> -> (ThreadState<A>, A), _ tvid : TVID) {
		self.val = val
		self.tvid = tvid
	}
}

//public func newTVar<A>(x : A) -> STM<TVar<A>> {
//	return STM({ (let rw) in
//		return (rw, TVar({ (let stv) in
//			var st : ThreadState<A> = stv
//			st.tidCount++
//			let nTID = TID(magic: 20072007, threadID: pthread_self(), localID: st.tidCount)
//			let nTVID = TVID(tid: nTID, direct: [])
//			let nLogItem = LogItem(preVersion: .None, newValue: .Some(x))
//			st.log = insert(nTVID)(val: nLogItem)(m: st.log)
//			return (stv, x)
//		}))
//	})
//}

//public func readTVar<A>(tv : TVar<A>) -> A {
//	return STM({ (let st) in
//		switch 
//	})
//}

//public func writeTVar<A>(tv : TVar<A>)(v : A) -> STM<()> {
//	return STM({ (let oldSt) in
//		var st : ThreadState<()> = oldSt
//		let newVal : A! = .Some(v)
//		switch lookup(tv.tvid)(m: st.log) {
//			case .None:
//				let nLog = LogItem(preVersion: .None, newValue: .Some(v))
//				st.log = insert(tv.tvid)(val: nLog)(m: st.log)
//			case .Some(let val):
//				let nLog = LogItem(preVersion: val.preVersion, newValue: .Some(v))
//				st.log = insert(tv.tvid)(val: nLog)(m: st.log)
//		}
//		return (st, ())
//	})
//}



