//
//  Traverse.swift
//  Basis
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Map a function over all values in the map.
public func map<K, A, B>(f : A -> B) -> Map<K, A> -> Map<K, B> {
	return { m in
		switch m.destruct() {
			case .Empty:
				return empty()
			case .Destructure(let c, let key, let x, let l, let r):
				return Map(c, key, f(x), map(f)(l), map(f)(r))
		}
	}
}

/// Map a function over all keys and values in the map.
public func mapWithKey<K, A, B>(f : K -> A -> B) -> Map<K, A> -> Map<K, B> {
	return { m in
		switch m.destruct() {
			case .Empty:
				return empty()
			case .Destructure(let c, let key, let x, let l, let r):
				return Map(c, key, f(key)(x), mapWithKey(f)(l), mapWithKey(f)(r))
		}
	}
}

/// Post-order fold of a function over the map.
public func foldr<K, A, B>(f : A -> B -> B) -> B -> Map<K, A> -> B {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, _, let x, let l, let r):
				return foldr(f)(f(x)(foldr(f)(z)(r)))(l)
		}
	} }
}

/// Post-order fold of an operator over the map.
public func foldr<K, A, B>(f : (A , B) -> B) -> B -> Map<K, A> -> B {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, _, let x, let l, let r):
				return foldr(f)(f(x, foldr(f)(z)(r)))(l)
		}
	} }
}

/// Pre-order fold of a function over the map.
public func foldl<K, A, B>(f: B -> A -> B) -> B -> Map<K, A> -> B {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, _, let x, let l, let r):
				return foldl(f)(f(foldl(f)(z)(l))(x))(r)
		}
	} }
}

/// Pre-order fold of an operator over the map.
public func foldl<K, A, B>(f: (B, A) -> B) -> B -> Map<K, A> -> B {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, _, let x, let l, let r):
				return foldl(f)(f(foldl(f)(z)(l), x))(r)
		}
	} }
}

/// Post-order fold of a function over the keys a values of a map.
public func foldrWithKey<K, A, B>(f : K -> A -> B -> B) -> B -> Map<K, A> -> B {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, let k, let x, let l, let r):
				return foldrWithKey(f)(f(k)(x)(foldrWithKey(f)(z)(r)))(l)
		}
	} }
}

/// Pre-order fold of a function over the keys a values of a map.
public func foldlWithKey<K, A, B>(f: A -> K -> B -> A) -> A -> Map<K, B> -> A {
	return  { z in { m in
		switch m.destruct() {
			case .Empty:
				return z
			case .Destructure(_, let k, let x, let l, let r):
				return foldlWithKey(f)(f(foldlWithKey(f)(z)(l))(k)(x))(r)
		}
	} }
}

/// Returns an array of all values in the map in ascending order of their keys.
public func elems<K, A>(m : Map<K, A>) -> [A] {
	return foldr(+>)([])(m)
}

/// Returns an array of all keys in the map in ascending order.
public func keys<K, A>(m : Map<K, A>) -> [K] {
	return foldrWithKey({ (let x) in
		return { (_) in
			return { (let xs) in
				return x +> xs
			}
		}
	})([])(m)
}


