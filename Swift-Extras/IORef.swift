//
//  IORef.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class IORef<A> : K1<A> {
	var value : STRef<RealWorld, A>
	
	init(_ v : STRef<RealWorld, A>) {
		self.value = v
	}
	
	public func readIORef() -> IO<A> {
		return stToIO(value.readSTRef())
	}
	
	public func writeIORef(v: A) -> IO<()> {
		return stToIO(ST.fmap({ (_) in
			return ()
		})(value.writeSTRef(v)))
	}
	
	public func modifyIORef<B>(vfn : (A -> A)) -> IO<A> {
		return stToIO(value.modifySTRef(vfn)) >> self.readIORef()
	}
}

public func newIORef<A>(v: A) -> IO<IORef<A>> {
	return stRefToIO(STRef<RealWorld, A>(v)).bind({ (let vari) in
		return IO<IORef<A>>.pure(IORef(vari))
	})
}

private func stRefToIO<A>(m: STRef<RealWorld, A>) -> IO<STRef<RealWorld, A>> {
	return IO<STRef<RealWorld, A>>.pure(m)
}
