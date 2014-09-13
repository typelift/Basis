//
//  MVar.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/12/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class MVar<A> : K1<A> {
	private var val : (World<RealWorld>, A?)
	private let lock: UnsafeMutablePointer<pthread_mutex_t>
	private let takeCond: UnsafeMutablePointer<pthread_cond_t>
	private let putCond: UnsafeMutablePointer<pthread_cond_t>
	
	init(_ rw : World<RealWorld>) {
		self.val = (rw, .None)
		self.lock = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
		self.takeCond = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		self.putCond = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		
		pthread_mutex_init(self.lock, nil)
		pthread_cond_init(self.takeCond, nil)
		pthread_cond_init(self.putCond, nil)
	}
	
	deinit {
		self.lock.destroy()
		self.takeCond.destroy()
		self.putCond.destroy()
	}
}

public func newEmptyMVar<A>() -> IO<MVar<A>> {
	return IO({ (let rw) in
		return (rw, MVar(rw))
	})
}

public func newMVar<A>(x : A) -> IO<MVar<A>> {
	return newEmptyMVar() >>= {
		putMVar($0)(x: x) >> IO.pure($0)
	}
}

public func takeMVar<A>(m : MVar<A>) -> IO<A> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		while m.val.1 == nil {
			pthread_cond_wait(m.takeCond, m.lock)
		}
		let value = m.val.1!
		m.val = (rw, .None)
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, value)
	})
}

public func readMVar<A>(m : MVar<A>) -> IO<A> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		while m.val.1 == nil {
			pthread_cond_wait(m.takeCond, m.lock)
		}
		let value = m.val.1!
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, value)
	})
}

public func putMVar<A>(m : MVar<A>)(x: A) -> IO<()> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		while m.val.1 != nil {
			pthread_cond_wait(m.putCond, m.lock)
		}
		m.val = (rw, x)
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, ())
	})
}

public func tryTakeMVar<A>(m : MVar<A>) -> IO<Optional<A>> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		if m.val.1 == nil {
			return (rw, .None)
		}
		let value = m.val.1!
		m.val = (rw, .None)
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, value)
	})
}

public func tryPutMVar<A>(m : MVar<A>)(x: A) -> IO<Bool> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		if m.val.1 != nil {
			return (rw, false)
		}
		m.val = (rw, x)
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, true)
	})
}

public func tryReadMVar<A>(m : MVar<A>) -> IO<Optional<A>> {
	return IO({ (let rw) in
		pthread_mutex_lock(m.lock)
		if m.val.1 == nil {
			return (rw, .None)
		}
		let value = m.val.1!
		pthread_cond_signal(m.putCond)
		pthread_mutex_unlock(m.lock)
		return (rw, value)
	})
}

public func isEmptyMVar<A>(m : MVar<A>) -> IO<Bool> {
	return IO({ (let rw) in
		return (rw, m.val.1 == nil)
	})
}

public func swapMVar<A>(m : MVar<A>)(x : A) -> IO<A> {
	return do_ { () -> A in
		var old : A! = nil
		old <- takeMVar(m)
		putMVar(m)(x: x)
		return old!
	}
}

public func withMVar<A, B>(m : MVar<A>)(f : A -> IO<B>) -> IO<B> {
	return do_ { () -> B in
		var a : A!
		var b : B!
		
		a <- takeMVar(m)
		b <- f(a)
		putMVar(m)(x: a)
		return b!
	}	
}

public func modifyMVar_<A>(m : MVar<A>)(f : A -> IO<A>) -> IO<()> {
	return do_({ () -> () in
		var a : A! = nil
		var a1 : A! = nil

		a <- takeMVar(m)
		a1 <- f(a)
		putMVar(m)(x : a1)
	})
}

public func modifyMVar<A, B>(m : MVar<A>)(f : A -> IO<(A, B)>) -> IO<B> {
	return do_({ () -> B in
		var a : A! = nil
		var t : (A, B)! = nil
		
		a <- takeMVar(m)
		t <- f(a)
		putMVar(m)(x: t.0)
		return t.1
	})
}


