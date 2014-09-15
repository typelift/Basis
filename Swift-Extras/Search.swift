//
//  Search.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Returns whether an element is a member of a list.
public func elem<A : Equatable>(e : A)(l : [A]) -> Bool {
	return any({ $0 == e })(l: l)
}

/// Returns whether an element is not a member of a list.
public func notElem<A : Equatable>(e : A)(l : [A]) -> Bool {
	return all({ $0 != e })(l: l)
}

/// Looks up a key in a list of key-value pairs.
public func lookup<A : Equatable, B>(e : A)(d : [A:B]) -> Optional<B> {
	switch destructure(d) {
		case .Empty:
			return .None
		case .Destructure(let (x, y), let xys):
			if e == x {
				return .Some(y)
			}
			return lookup(e)(d: xys)
	}
}

/// Looks up a key in a dictionary.
public func lookup<A : Equatable, B>(e : A)(d : [(A, B)]) -> Optional<B> {
	switch d.destruct() {
		case .Empty:
			return .None
		case .Destructure(let (x, y), let xys):
			if e == x {
				return .Some(y)
			}
			return lookup(e)(d: xys)
	}
}
