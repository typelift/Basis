//
//  Query.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func null<K, A>(m : Map<K, A>) -> Bool {
	switch m.destruct() {
		case .Empty:
			return true
		case .Destructure(_, _, _, _, _):
			return false
	}
}

public func size<K, A>(m : Map<K, A>) -> UInt {
	switch m.destruct() {
		case .Empty:
			return 0
		case .Destructure(let sz, _, _, _, _):
			return sz
	}
}

public func lookup<K : Comparable, A>(key : K)(m : Map<K, A>) -> Optional<A> {
	switch m.destruct() {
		case .Empty:
			return .None
		case .Destructure(_, let kx,let x, let l, let r):
			if key < kx {
				return lookup(key)(m: l)
			} else if key > kx {
				return lookup(key)(m: r)
			}
			return .Some(x)
	}
}

public func member<K : Comparable, A>(key : K)(m : Map<K, A>) -> Bool {
	switch m.destruct() {
		case .Empty:
			return false
		case .Destructure(_, let kx,let x, let l, let r):
			if key < kx {
				return member(key)(m: l)
			} else if key > kx {
				return member(key)(m: r)
			}
			return true
	}
}

public func notMember<K : Comparable, A>(key : K)(m : Map<K, A>) -> Bool {
	return !member(key)(m: m)
}

public func find<K : Comparable, A>(key : K)(m : Map<K, A>) -> A {
	switch m.destruct() {
		case .Empty:
			return error("Key is not a member of this map.")
		case .Destructure(_, let kx,let x, let l, let r):
			if key < kx {
				return find(key)(m: l)
			} else if key > kx {
				return find(key)(m: r)
			}
			return x
	}
}

public func findWithDefault<K : Comparable, A>(def: A)(key : K)(m : Map<K, A>) -> A {
	switch m.destruct() {
		case .Empty:
			return def
		case .Destructure(_, let kx,let x, let l, let r):
			if key < kx {
				return findWithDefault(def)(key: key)(m: l)
			} else if key > kx {
				return findWithDefault(def)(key: key)(m: r)
			}
			return x
	}
}
