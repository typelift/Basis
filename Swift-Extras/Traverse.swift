//
//  Traverse.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func map<K, A, B>(f : A -> B)(m : Map<K, A>) -> Map<K, B> {
	switch m.destruct() {
		case .Empty:
			return empty()
		case .Destructure(let c, let key, let x, let l, let r):
			return Map(c, key, f(x), map(f)(m: l), map(f)(m: r))
	}
}

public func mapWithKey<K, A, B>(f : K -> A -> B)(m : Map<K, A>) -> Map<K, B> {
	switch m.destruct() {
		case .Empty:
			return empty()
		case .Destructure(let c, let key, let x, let l, let r):
			return Map(c, key, f(key)(x), mapWithKey(f)(m: l), mapWithKey(f)(m: r))
	}
}

public func foldr<K, A, B>(f : A -> B -> B)(z : B)(m : Map<K, A>) -> B {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, _, let x, let l, let r):
			return foldr(f)(z: f(x)(foldr(f)(z: z)(m: r)))(m: l)
	}
}

public func foldr<K, A, B>(f : (A , B) -> B)(z : B)(m : Map<K, A>) -> B {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, _, let x, let l, let r):
			return foldr(f)(z: f(x, foldr(f)(z: z)(m: r)))(m: l)
	}
}

public func foldl<K, A, B>(f: B -> A -> B) (z: B)(m : Map<K, A>) -> B {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, _, let x, let l, let r):
			return foldl(f)(z: f(foldl(f)(z: z)(m: l))(x))(m: r)
	}
}

public func foldl<K, A, B>(f: (B, A) -> B) (z: B)(m : Map<K, A>) -> B {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, _, let x, let l, let r):
			return foldl(f)(z: f(foldl(f)(z: z)(m: l), x))(m: r)
	}
}


public func foldrWithKey<K, A, B>(f : K -> A -> B -> B)(z : B)(m : Map<K, A>) -> B {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, let k, let x, let l, let r):
			return foldrWithKey(f)(z: f(k)(x)(foldrWithKey(f)(z: z)(m: r)))(m: l)
	}
}

public func foldlWithKey<K, A, B>(f: A -> K -> B -> A) (z: A)(m : Map<K, B>) -> A {
	switch m.destruct() {
		case .Empty:
			return z
		case .Destructure(_, let k, let x, let l, let r):
			return foldlWithKey(f)(z: f(foldlWithKey(f)(z: z)(m: l))(k)(x))(m: r)
	}
}

public func elems<K, A>(m : Map<K, A>) -> [A] {
	return foldr(+>)(z: [])(m: m)
}

public func keys<K, A>(m : Map<K, A>) -> [K] {
	return foldrWithKey({ (let x) in
		return { (_) in
			return { (let xs) in
				return x +> xs
			}
		}
	})(z: [])(m: m)
}


