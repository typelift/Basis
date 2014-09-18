//
//  MVar.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/12/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// MVars (literally "Mutable Variables") are mutable references that are either empty or contain a
/// value of type A.  An MVar is often compared to a box, or to a diner in that if there is no value
/// in the box (no food in the restaurant), you have to wait, possibly in line, before you can get
/// what you want.  In this way, they are "Synchronization Primitives" that can be used to make
/// multiple threads wait on the appropriate value before proceeding with a computation.
public final class MVar<A> : K1<A> {
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

/// Creates a new empty MVar.
public func newEmptyMVar<A>() -> IO<MVar<A>> {
	return IO({ (let rw) in
		return (rw, MVar(rw))
	})
}

/// Creates a new MVar containing the supplied value.
public func newMVar<A>(x : A) -> IO<MVar<A>> {
	return newEmptyMVar() >>- {
		putMVar($0)(x: x) >> IO.pure($0)
	}
}

/// Returns the contents of the MVar.
///
/// If the MVar is empty, this will block until a value is put into the MVar.  If the MVar is full,
/// the value is wrapped up in an IO computation and the MVar is emptied.
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

/// Atomically reads the contents of an MVar.
///
/// If the MVar is currently empty, this will block until a value is put into it.  If the MVar is
/// ful, the value is wrapped up in an IO computation, but the MVar remains full.
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

/// Puts a value into an MVar.
///
/// If the MVar is currently full, the function will block until it becomes empty again.
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

/// Attempts to return the contents of the MVar without blocking.
///
/// If the MVar is empty, this will immediately returns a None wrapped in an IO computation.  If the
/// MVar is full, the value is wrapped up in an IO computation and the MVar is emptied.
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

/// Attempts to put a value into an MVar without blocking.
///
/// If the MVar is empty, this will immediately returns a true wrapped in an IO computation.  If the
/// MVar is full, nothing occurs and a false is returned in an IO computation.
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

/// Attempts to read the contents of an MVar without blocking.
///
/// If the MVar is empty, this function returns a None in an IO computation.  If the MVar is full,
/// this function wraps the value in a Some and an IO computation and returns immediately.
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

/// Checks whether a given MVar is empty.
///
/// This function is just a snapshot of the state of the MVar at that point in time.  In heavily 
/// concurrent computations, this may change out from under you without warning, or even by the time
/// it can be acted on.  It is better to use one of the direct actions above.
public func isEmptyMVar<A>(m : MVar<A>) -> IO<Bool> {
	return IO({ (let rw) in
		return (rw, m.val.1 == nil)
	})
}

/// Atomically, take a value from the MVar, put a new value in the MVar, then return the old value 
/// in an IO computation.
public func swapMVar<A>(m : MVar<A>)(x : A) -> IO<A> {
	return do_ { () -> A in
		var old : A! = nil
		old <- takeMVar(m)
		putMVar(m)(x: x)
		return old!
	}
}

///
public func withMVar<A, B>(m : MVar<A>)(f : A -> IO<B>) -> IO<B> {
	return mask({ (let restore : (IO<B> -> IO<B>)) -> IO<B> in
		return do_ { () -> B in
			var a : A!
			var b : B!
			
			a <- takeMVar(m)
			b <- catchException(restore(f(a)))({ (let e) in
				return do_ { () -> IO<B> in
					return putMVar(m)(x: a) >> throw(e)
				}
			})
			putMVar(m)(x: a)
			return b!
		}	
	})
}

/// 
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


