//
//  Weak.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public struct ChItem<A> {
	let val : A
	let stream : MVar<ChItem<A>>
}

/// Channels are unbounded FIFO streams of values with a read and write terminals comprised of
/// MVars.
public class Chan<A> : K1<A> {
	let readEnd : MVar<MVar<ChItem<A>>>
	let writeEnd : MVar<MVar<ChItem<A>>>
	
	init(read : MVar<MVar<ChItem<A>>>, write: MVar<MVar<ChItem<A>>>) {
		self.readEnd = read
		self.writeEnd = write
	}
}

/// Creates and returns a new empty channel.
public func newChan<A>() -> IO<Chan<A>> {
	return do_({ () -> Chan<A> in
		var hole : MVar<ChItem<A>>! = nil
		var readVar : MVar<MVar<ChItem<A>>>!
		var writeVar :MVar<MVar<ChItem<A>>>!

		hole <- newEmptyMVar()
		readVar <- newMVar(hole)
		writeVar <- newMVar(hole)
		return Chan(read: readVar, write: writeVar)
	})
}

/// Writes a value to a channel.
public func writeChan<A>(c : Chan<A>)(x : A) -> IO<()> {
	return do_({ () -> () in
		var newHole : MVar<ChItem<A>>!
		var oldHole : MVar<ChItem<A>>!
		
		newHole <- newEmptyMVar()
		oldHole <- takeMVar(c.writeEnd)
		putMVar(oldHole)(x : ChItem(val: x, stream: newHole))
		putMVar(c.writeEnd)(x: newHole)
	})
}

/// Reads a value from the channel.
public func readChan<A>(c : Chan<A>) -> IO<A> {
	return do_({ () -> IO<A> in
		return modifyMVar(c.readEnd)({ (let readEnd) in
			return do_({ () -> (MVar<ChItem<A>>, A) in
				var item : ChItem<A>! = nil
				
				item <- readMVar(readEnd)
				return (item.stream, item.val)
			})
		})
	})
}

/// Duplicates a channel.
///
/// The duplicate channel begins empty, but data written to either channel from then on will be 
/// available from both. Because both channels share the same write end, data inserted into one
/// channel may be read by both channels.
public func dupChan<A>(c : Chan<A>) -> IO<Chan<A>> {
	return do_({ () -> Chan<A> in
		var hole : MVar<ChItem<A>>!
		var newReadVar : MVar<MVar<ChItem<A>>>!
		
		hole <- readMVar(c.writeEnd)
		newReadVar <- newMVar(hole)
		return Chan(read: newReadVar, write: c.writeEnd)
	})
}


