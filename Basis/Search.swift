//
//  Search.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Returns whether an element is a member of a list.
public func elem<A : Equatable>(e : A) -> [A] -> Bool {
	return { l in any({ $0 == e })(l) }
}

/// Returns whether an element is not a member of a list.
public func notElem<A : Equatable>(e : A) -> [A] -> Bool {
	return { l in all({ $0 != e })(l) }
}

/// Looks up a key in a list of key-value pairs.
public func lookup<A : Equatable, B>(e : A) -> [A:B] -> Optional<B> {
	return { d in
		switch destructure(d) {
			case .Empty:
				return .None
			case .Destructure(let (x, y), let xys):
				if e == x {
					return .Some(y)
				}
				return lookup(e)(xys)
		}
	}
}

/// Looks up a key in a dictionary.
public func lookup<A : Equatable, B>(e : A) -> [(A, B)] -> Optional<B> {
	return { d in
		switch d.destruct() {
			case .Empty:
				return .None
			case .Destructure(let (x, y), let xys):
				if e == x {
					return .Some(y)
				}
				return lookup(e)(xys)
		}
	}
}
