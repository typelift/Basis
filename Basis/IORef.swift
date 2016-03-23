//
//  IORef.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Mutable references in the IO monad.
public final class IORef<A> : K1<A> {
	let value : STRef<RealWorld, A>
	
	init(_ v : STRef<RealWorld, A>) {
		self.value = v
	}
}

/// Creates and returns a new IORef
public func newIORef<A>(v: A) -> IO<IORef<A>> {
  fatalError()
//	return stRefToIO(STRef<RealWorld, A>(v)) >>- { l in IO<IORef<A>>.pure(IORef(l)) }
}

/// Reads a value from an IORef.
public func readIORef<A>(ref : IORef<A>) -> IO<A> {
	return stToIO(readSTRef(ref.value))
}

/// Writes a value to the IORef
public func writeIORef<A>(ref : IORef<A>) -> A -> IO<Void> {
    return { v in 
        return stToIO(ST.fmap({ (_) in
            return ()
        })(writeSTRef(ref.value)(v)))
    }
}

/// Applies a function to the contents of the IORef
public func modifyIORef<A>(ref : IORef<A>) -> (A -> A) -> IO<Void> {
    return { vfn in stToIO(modifySTRef(ref.value)(vfn)) >> IO.pure(()) }
}

// MARK: Equatable

// Simple reference equality when we've got two objects.
public func == <T : AnyObject>(lhs : IORef<T>, rhs : IORef<T>) -> Bool {
	return lhs.value == rhs.value
}

public func != <T : AnyObject>(lhs : IORef<T>, rhs : IORef<T>) -> Bool {
	return !(lhs == rhs)
}


/// Not for human eyes
private func stRefToIO<A>(m : STRef<RealWorld, A>) -> IO<STRef<RealWorld, A>> {
	return IO<STRef<RealWorld, A>>.pure(m)
}
