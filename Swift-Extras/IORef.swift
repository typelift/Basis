//
//  IORef.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public final class IORef<A> : K1<A> {
	var value : STRef<RealWorld, A>
	
	init(_ v : STRef<RealWorld, A>) {
		self.value = v
	}
}

public func newIORef<A>(v: A) -> IO<IORef<A>> {
	return stRefToIO(STRef<RealWorld, A>(v)).bind({ (let vari) in
		return IO<IORef<A>>.pure(IORef(vari))
	})
}

public func readIORef<A>(ref : IORef<A>) -> IO<A> {
	return stToIO(readSTRef(ref.value))
}

public func writeIORef<A>(ref : IORef<A>)(v: A) -> IO<()> {
	return stToIO(ST.fmap({ (_) in
		return ()
	})(writeSTRef(ref.value)(a: v)))
}

public func modifyIORef<A, B>(ref : IORef<A>)(vfn : (A -> A)) -> IO<A> {
	return stToIO(modifySTRef(ref.value)(vfn)) >> readIORef(ref)
}

private func stRefToIO<A>(m: STRef<RealWorld, A>) -> IO<STRef<RealWorld, A>> {
	return IO<STRef<RealWorld, A>>.pure(m)
}
