//
//  QSem.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class QSem : K0 {
	var contents : MVar<(UInt, [MVar<()>], [MVar<()>])>
	
	init(_ c : MVar<(UInt, [MVar<()>], [MVar<()>])>){
		self.contents = c
	}
}

public func newQSem(initial : UInt) -> IO<QSem> {
	return do_({ () -> QSem in
		var sem : MVar<(UInt, [MVar<()>], [MVar<()>])>!
		
		sem <- newMVar((initial, [], []))
		return QSem(sem)
	})
}

public func waitQSem(q : QSem) -> IO<()> {
	return do_({ () -> () in
		var t : (UInt, [MVar<()>], [MVar<()>])!
		
		t <- takeMVar(q.contents)
		if t.0 == 0 {
			var b : MVar<()>!
			
			b <- newEmptyMVar()
			putMVar(q.contents)(x : (t.0, t.1, b +> t.2))
			takeMVar(b)
		} else {
			putMVar(q.contents)(x : (t.0 - 1, t.1, t.2))
		}
	})
}

public func signalQSem(q : QSem) -> IO<()> {
	return do_({ () -> () in
		var t : (UInt, [MVar<()>], [MVar<()>])!
		var r : (UInt, [MVar<()>], [MVar<()>])!

		t <- takeMVar(q.contents)
		r <- signal(t)
		putMVar(q.contents)(x : r)
	})
}

private func signal(t : (UInt, [MVar<()>], [MVar<()>])) -> IO<(UInt, [MVar<()>], [MVar<()>])> {
	switch t {
		case (let i, let a1, let a2):
			if i == 0 {
				return loop(a1, a2)
			}
			let t : (UInt, [MVar<()>], [MVar<()>]) = (i + 1, a1, a2)
			return IO.pure(t)
	}
}

private func loop(b : [MVar<()>], b2 : [MVar<()>]) -> IO<(UInt, [MVar<()>], [MVar<()>])> {
	if b.count == 0 && b2.count == 0 {
		let t : (UInt, [MVar<()>], [MVar<()>]) = (1, [], [])
		return IO.pure(t)
	} else if b2.count != 0 {
		return loop(b2.reverse(), [])
	}
	return do_({ () -> IO<(UInt, [MVar<()>], [MVar<()>])> in
		switch b.destruct() {
		case .Destructure(let b, let bs):
			var r : Bool!
			
			r <- tryPutMVar(b)(x : ())
			if r! {
				let t : (UInt, [MVar<()>], [MVar<()>]) = (0, bs, b2)
				return IO.pure(t)
			}
			return loop(bs, b2)
		case .Empty:
			assert(false, "")
		}
	})
}
