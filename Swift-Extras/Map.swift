//
//  Map.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/16/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public enum MapD<K, A> {
	case Empty
	case Destructure(UInt, K, A, Map<K, A>, Map<K, A>)
}

public class Map<K, A> : K2<K, A> {
	let size : UInt
	let k : K!
	let a : A!
	let l : Map<K, A>!
	let r : Map<K, A>!
	
	init(_ size : UInt, _ k : K!, _ a : A!, _ l : Map<K, A>!, _ r : Map<K, A>!) {
		self.size = size
		self.k = k
		self.a = a
		self.l = l
		self.r = r
	}
	
	public func destruct() -> MapD<K, A> {
		if self.size == 0 {
			return .Empty
		}
		return .Destructure(size, k, a, l, r)
	}
}

public func empty<K, A>() -> Map<K, A> {
	return Map<K, A>(0, nil, nil, nil, nil)
}

public func singleton<K, A>(key : K)(val : A) -> Map<K, A> {
	return Map<K, A>(1, key, val, nil, nil)
}

public func insert<K : Comparable, A>(key : K)(val : A)(m: Map<K, A>) -> Map<K, A> {
	switch m.destruct() {
		case .Empty:
			return singleton(key)(val: val)
		case .Destructure(let sz, let ky, let y, let l, let r):
			if key < ky {
				return balance(ky)(x: y)(l: insert(key)(val: val)(m: l))(r: r)
			} else if key > ky {
				return balance(ky)(x: y)(l: l)(r: insert(key)(val: val)(m: r))
			}
			return Map(sz, key, val, l, r)
	}
}

public func insertR<K : Comparable, A>(key : K)(val : A)(m: Map<K, A>) -> Map<K, A> {
	switch m.destruct() {
		case .Empty:
			return singleton(key)(val: val)
		case .Destructure(let sz, let ky, let y, let l, let r):
			if key < ky {
				return balance(ky)(x: y)(l: insert(key)(val: val)(m: l))(r: r)
			} else if key > ky {
				return balance(ky)(x: y)(l: l)(r: insert(key)(val: val)(m: r))
			}
			return m
	}
}

public func insertWith<K : Comparable, A>(f : A -> A -> A)(key : K)(val : A)(m : Map<K, A>) -> Map<K, A> {
	let fn : K -> A -> A -> A = { (_) in
		return { (let x) in
			return { (let y) in
				return f(x)(y)
			}
		}
	}
	return insertWithKey(fn)(key: key)(val: val)(m: m)
}

public func insertWithKey<K : Comparable, A>(f : K -> A -> A -> A)(key : K)(val : A)(m : Map<K, A>) -> Map<K, A> {
	switch m.destruct() {
		case .Empty:
			return singleton(key)(val: val)
		case .Destructure(let sy, let ky, let y, let l, let r):
			if key < ky {
				return balance(ky)(x: y)(l: insertWithKey(f)(key: key)(val: val)(m: l))(r: r)
			} else if key > ky {
				return balance(ky)(x: y)(l: l)(r: insertWithKey(f)(key: key)(val: val)(m: r))
			}
			return Map(sy, key, (f(key)(val)(y)), l, r)
	}
}

public func delete<K : Comparable, A>(k : K)(m : Map<K, A>) -> Map<K, A> {
	switch m.destruct() {
		case .Empty:
			return empty()
		case .Destructure(_, let kx, let x, let l, let r):
			if k < kx {
				return balance(kx)(x: x)(l: delete(k)(m: m))(r: r)
			} else if k > kx {
				return balance(kx)(x: x)(l: l)(r: delete(k)(m: m))
			}
			return glue(l, r)
	}
}

public func deleteFindMin<K, A>(m : Map<K, A>) -> ((K, A), Map<K, A>) {
	switch m.destruct() {
		case .Empty:
			return error("")
		case .Destructure(_, let k, let x, let l, let r):
			switch l.destruct() {
				case .Empty:
					return ((k, x), r)
				case .Destructure(_, _, _, _, _):
					let (km, l1) = deleteFindMin(l)
					return (km, balance(k)(x: x)(l: l1)(r: r))
			}
	}
}

public func deleteFindMax<K, A>(m : Map<K, A>) -> ((K, A), Map<K, A>) {
	switch m.destruct() {
		case .Empty:
			return error("")
		case .Destructure(_, let k, let x, let l, let r):
			switch l.destruct() {
				case .Empty:
					return ((k, x), r)
				case .Destructure(_, _, _, _, _):
					let (km, r1) = deleteFindMin(l)
					return (km, balance(k)(x: x)(l: l)(r: r1))
			}
	}
}

/// Balancing based on unoptimized algorithm in Data.Map.Base
/// http://www.haskell.org/ghc/docs/7.8.3/html/libraries/containers-0.5.5.1/src/Data-Map-Base.html#balance
/// which is, in turn, based on the paper
/// http://groups.csail.mit.edu/mac/users/adams/BB/
private func balance<K, A>(k : K)(x : A)(l : Map<K, A>)(r : Map<K, A>) -> Map<K, A> {
	if l.size + r.size <= 1 {
		return Map(l.size + r.size + 1, k, x, l, r)
	} else if r.size > l.size * 3 {
		return rotateL(k)(x: x)(l: l)(r: r)
	} else if l.size > r.size * 3 {
		return rotateR(k)(x: x)(l: l)(r: r)
	}
	return Map(l.size + r.size, k, x, l, r)
}

private func rotateL<K, A>(k : K)(x : A)(l : Map<K, A>)(r : Map<K, A>) -> Map<K, A> {
	switch r.destruct() {
		case .Empty:
			return error("")
		case .Destructure(_, _, _, let ly, let ry):
			if ly.size < 2 * ry.size {
				return single(k)(x1: x)(t1: l)(t2: r)
			}
			return double(k)(x1: x)(t1: l)(t2: r)
	}
}

private func rotateR<K, A>(k : K)(x : A)(l : Map<K, A>)(r : Map<K, A>) -> Map<K, A> {
	switch l.destruct() {
		case .Empty:
			return error("")
		case .Destructure(_, _, _, let ly, let ry):
			if ly.size < 2 * ry.size {
				return single(k)(x1: x)(t1: l)(t2: r)
			}
			return double(k)(x1: x)(t1: l)(t2: r)
	}
}

private func single<K, A>(k1 : K)(x1 : A)(t1 : Map<K, A>)(t2 : Map<K, A>) -> Map<K, A> {
	switch t2.destruct() {
		case .Empty:
			switch t1.destruct() {
				case .Empty:
					return error("")
				case .Destructure(_, let k2, let x2, let t1, let t3):
					return bin(k2, x2, t1, bin(k1, x1, t3, t2))
		}
		case .Destructure(_, let k2, let x2, let t2, let t3):
			return bin(k2, x2, bin(k1, x1, t1, t2), t3)
	}
}

private func double<K, A>(k1 : K)(x1 : A)(t1 : Map<K, A>)(t2 : Map<K, A>) -> Map<K, A> {
	switch t2.destruct() {
		case .Empty:
			switch t1.destruct() {
				case .Empty:
					return error("")
				case .Destructure(_, let k2, let x2, let b, let t4):
					switch b.destruct() {
						case .Empty:
							return error("")
						case .Destructure(_, let k3, let x3, let t2, let t3):
							return bin(k3, x3, bin(k2, x2, t1, t2), bin(k1, x1, t3, t4))
					}
			}
	case .Destructure(_, let k2, let x2, let b, let t4):
			switch b.destruct() {
				case .Empty:
					return error("")
				case .Destructure(_, let k3, let x3, let t2, let t3):
					return bin(k3, x3, bin(k1, x1, t1, t2), bin(k2, x2, t3, t4))
			}
	}
}

private func glue<K, A>(l : Map<K, A>, r : Map<K, A>) -> Map<K, A> {
	if l.size == 0 {
		return r
	}
	if r.size == 0 {
		return l
	}
	
	if l.size > r.size {
		let ((km, m), l1) = deleteFindMax(l)
		return balance(km)(x: m)(l: l1)(r: r)
	}
	let ((km, m), r1) = deleteFindMin(r)
	return balance(km)(x: m)(l: l)(r: r1)
}

private func bin<K, A>(k : K, x : A, l : Map<K, A>, r : Map<K, A>) -> Map<K, A> {
	return Map(l.size + r.size + 1, k, x, l, r)
}
