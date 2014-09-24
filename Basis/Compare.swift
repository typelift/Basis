//
//  Compare.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other according to an equality predicate.
public func groupBy<A>(cmp : A -> A -> Bool)(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			let (ys, zs) = span(cmp(x))(l: xs)
			return (x +> ys) +> groupBy(cmp)(l: zs)
	}
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other according to an equality operator.
public func groupBy<A>(cmp : (A, A) -> Bool)(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			let (ys, zs) = span({ cmp(x, $0) })(l: xs)
			return (x +> ys) +> groupBy(cmp)(l: zs)
	}
}

/// Removes duplicates from a list according to an equality predicate.
public func nubBy<A>(eq : A -> A -> Bool) -> [A] -> [A] {
	return { (let lst) in
		switch lst.destruct() {
			case .Empty():
				return []
			case .Destructure(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ (let y) in
					return !(eq(x)(y))
				}))
		}
	}
}

/// Removes duplicates from a list according to an equality operator.
public func nubBy<A>(eq : (A, A) -> Bool) -> [A] -> [A] {
	return { (let lst) in
		switch lst.destruct() {
			case .Empty():
				return []
			case .Destructure(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ (let y) in
					return !(eq(x, y))
				}))
		}
	}
}

/// Sorts a list according to a ordering predicate.
public func sortBy<A>(cmp : A -> A -> Bool)(l : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(l: l)
}

/// Sorts a list according to an ordering operator.
public func sortBy<A>(cmp : (A, A) -> Bool)(l : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(l: l)
}

/// Inserts an element into a list according to an ordering predicate.
public func insertBy<A>(cmp: A -> A -> Bool)(x : A)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x)(y) {
				return y +> insertBy(cmp)(x: x)(l: ys)
			}
			return x +> l
	}
}

/// Inserts an element into a list according to an ordering operator.
public func insertBy<A>(cmp: (A, A) -> Bool)(x : A)(l : [A]) -> [A]  {
	switch l.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x, y) {
				return y +> insertBy(cmp)(x: x)(l: ys)
			}
			return x +> l
	}
}

/// Returns the maximum element of a list according to an ordering predicate.
public func maximumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(fst(t))(snd(t)) {
						return fst(t)
					}
					return snd(t)
				})(l: $0)
		}
	}
}

/// Returns the maximum element of a list according to an ordering operator.
public func maximumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(fst(t), snd(t)) {
						return fst(t)
					}
					return snd(t)
				})(l: $0)
		}
	}
}

/// Returns the minimum element of a list according to an ordering predicate.
public func minimumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(fst(t))(snd(t)) {
						return snd(t)
					}
					return fst(t)
				})(l: $0)
		}
	}
}

/// Returns the minimum element of a list according to an ordering operator.
public func minimumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(fst(t), snd(t)) {
						return snd(t)
					}
					return fst(t)
				})(l: $0)
		}
	}
}

