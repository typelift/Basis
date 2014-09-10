//
//  Search.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func elem<A : Equatable>(e : A)(l : [A]) -> Bool {
	return any({ $0 == e })(l: l)
}

public func notElem<A : Equatable>(e : A)(l : [A]) -> Bool {
	return all({ $0 != e })(l: l)
}

public func lookup<A : Equatable, B>(e : A)(d : [A:B]) -> Optional<B> {
	switch destructure(d) {
		case .Empty():
			return .None
		case .Destructure(let (x, y), let xys):
			if e == x {
				return .Some(y)
			}
			return lookup(e)(d: xys)
	}
}

public func lookup<A : Equatable, B>(e : A)(d : [(A, B)]) -> Optional<B> {
	switch d.destruct() {
		case .Empty():
			return .None
		case .Destructure(let (x, y), let xys):
			if e == x {
				return .Some(y)
			}
			return lookup(e)(d: xys)
	}
}
