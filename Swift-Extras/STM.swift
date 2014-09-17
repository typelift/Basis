//
//  STM.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/15/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public final class STM<A> : K1<A> {
	internal let apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)

	private let lock: UnsafeMutablePointer<pthread_mutex_t>
	private let readCond: UnsafeMutablePointer<pthread_cond_t>
	private let writeCond: UnsafeMutablePointer<pthread_cond_t>
	
	private var currentWriter : Optional<(ThreadID, UInt)>
	private var readers : UInt = 0
	private var writers : UInt = 0
	
	init(apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)) {
		self.apply = apply
		self.lock = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
		self.readCond = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		self.writeCond = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		
		pthread_mutex_init(self.lock, nil)
		pthread_cond_init(self.readCond, nil)
		pthread_cond_init(self.writeCond, nil)
	}
	
	deinit {
		self.lock.destroy()
		self.readCond.destroy()
		self.writeCond.destroy()
	}
}

extension STM : Functor {
	typealias B = Any
	
	public class func fmap<B>(f : A -> B) -> STM<A> -> STM<B> {
		return { (let stm) in
			return stm >>- { STM<B>.pure(f($0)) }
		}
	}
}

public func <%><A, B>(f: A -> B, stm : STM<A>) -> STM<B> {
	return STM.fmap(f)(stm)
}

public func <^ <A, B>(x : A, stm : STM<B>) -> STM<A> {
	return STM.fmap(const(x))(stm)
}

extension STM : Applicative {
	public class func pure(x : A) -> STM<A> {
		return STM({ (let rw) in
			return (rw, x)
		})
	}
}

public func <*><A, B>(fn: STM<A -> B>, m: STM<A>) -> STM<B> {
	return STM<B>({ (let rw) in
		let f = unSTM(fn)(rw).1
		let (nw, x) = unSTM(m)(rw)
		return (nw, f(x))
	})
}

public func *> <A, B>(a : STM<A>, b : STM<B>) -> STM<B> {
	return const(id) <%> a <*> b
}

public func <* <A, B>(a : STM<A>, b : STM<B>) -> STM<A> {
	return const <%> a <*> b
}

extension STM : Monad {
	public func bind<B>(f: A -> STM<B>) -> STM<B> {
		return STM<B>({ (let rw) in
			let (nw, a) = unSTM(self)(rw)
			return unSTM(f(a))(rw)
		})
	}
}

public func >>-<A, B>(x: STM<A>, f: A -> STM<B>) -> STM<B> {
	return x.bind(f)
}

public func >><A, B>(x: STM<A>, y: STM<B>) -> STM<B> {
	return x.bind({ (_) in
		return y
	})
}

//extension STM : MonadPlus {
//	public func mzero() -> STM<A> {
//		return retry(self)
//	}
//	
//	public func mplus(stm : STM<A>) -> STM<A> -> STM<A> {
//		return { orElse(stm, $0) }
//	}
//}

private func write<A>(stm : STM<A>) {
	let thrID = pthread_self()
	pthread_mutex_lock(stm.lock)
	switch stm.currentWriter {
		case .Some(let t) where thrID == t.0:
			stm.currentWriter = .Some((thrID, t.1 + 1) as (ThreadID, UInt))
		case .None where stm.readers == 0 && stm.writers == 0:
			stm.currentWriter = .Some((thrID, 1) as (ThreadID, UInt))
		default:
			stm.writers += 1
			pthread_cond_wait(stm.writeCond, stm.lock) 
			stm.writers -= 1
			stm.currentWriter = .Some((thrID, 1) as (ThreadID, UInt))
	}
	pthread_mutex_unlock(stm.lock)
}

private func endWrite<A>(stm : STM<A>) {
	pthread_mutex_lock(stm.lock)
	switch stm.currentWriter {
	case .None:
		assert(false, "")
	case .Some(let t):
		if t.1 == 1 {
			stm.currentWriter = .None
			if stm.writers > 0 {
				pthread_cond_signal(stm.writeCond)
			} else {
				pthread_cond_broadcast(stm.readCond)
			}
		} else {
			stm.currentWriter = .Some(t.0, t.1 - 1)
		}
	}
	pthread_mutex_unlock(stm.lock)
}


private func read<A>(stm : STM<A>) {
	pthread_mutex_lock(stm.lock)
	while stm.currentWriter != nil || stm.writers > 0 {
		pthread_cond_wait(stm.readCond, stm.lock)
	}
	stm.readers += 1
	pthread_mutex_unlock(stm.lock)
}

private func endRead<A>(stm : STM<A>) {
	pthread_mutex_lock(stm.lock)
	stm.readers -= 1
	if stm.readers == 0 {
		pthread_cond_signal(stm.writeCond)
	}
	pthread_mutex_unlock(stm.lock)
}

private func unSTM<A>(stm : STM<A>) -> World<RealWorld> -> (World<RealWorld>, A) {
	return stm.apply
}

public func unsafeIOToSTM<A>(io : IO<A>) -> STM<A> {
	return STM(io.apply)
}
