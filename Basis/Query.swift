//
//  Query.swift
//  Basis
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Returns whether a map is empty in constant time.
public func null<K, A>(_ m : Map<K, A>) -> Bool {
	switch m.match() {
		case .empty:
			return true
		case .destructure(_, _, _, _, _):
			return false
	}
}

/// Returns the size of a map in constant time.
public func size<K, A>(_ m : Map<K, A>) -> UInt {
	switch m.match() {
		case .empty:
			return 0
		case .destructure(let sz, _, _, _, _):
			return sz
	}
}

/// Looks up the value associated with a key in the map.
///
/// If the key does not exist, this function returns None.  Else is returns that value in a Some.
public func lookup<K : Comparable, A>(_ key : K) -> (Map<K, A>) -> Optional<A> {
	return { m in
		switch m.match() {
			case .empty:
				return .none
			case .destructure(_, let kx,let x, let l, let r):
				if key < kx {
					return lookup(key)(l)
				} else if key > kx {
					return lookup(key)(r)
				}
				return .some(x)
		}
	}
}

/// Returns whether a given key is a member of the map.
public func member<K : Comparable, A>(_ key : K) -> (Map<K, A>) -> Bool {
	return { m in
		switch m.match() {
			case .empty:
				return false
			case .destructure(_, let kx, _, let l, let r):
				if key < kx {
					return member(key)(l)
				} else if key > kx {
					return member(key)(r)
				}
				return true
		}
	}
}

/// Returns whether a given key is not a member of the map.
public func notMember<K : Comparable, A>(_ key : K) -> (Map<K, A>) -> Bool {
	return { m in !member(key)(m) }
}

/// Finds the value associated with a key in the map.
///
/// If this given key is not a member of the map, this function throws an exception.
public func find<K : Comparable, A>(_ key : K) -> (Map<K, A>) -> A {
	return { m in
		switch m.match() {
			case .empty:
				return error("Key is not a member of this map.")
			case .destructure(_, let kx,let x, let l, let r):
				if key < kx {
					return find(key)(l)
				} else if key > kx {
					return find(key)(r)
				}
				return x
		}
	}
}

/// Finds the value associated with a key in the map, returning a default value if no such key is a
/// member of the map.
public func findWithDefault<K : Comparable, A>(_ def: A) -> (K) -> (Map<K, A>) -> A {
	return { key in { m in
		switch m.match() {
			case .empty:
				return def
			case .destructure(_, let kx,let x, let l, let r):
				if key < kx {
					return findWithDefault(def)(key)(l)
				} else if key > kx {
					return findWithDefault(def)(key)(r)
				}
				return x
		}
	} }
}
