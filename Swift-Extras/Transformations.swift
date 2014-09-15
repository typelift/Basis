//
//  Transformations.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Maps a function over a list and returns a new list containing the mapped values.
public func map<A, B>(f : A -> B)(l : [A]) -> [B] {
	return l.map(f)
}

/// Takes a separator and a list and intersperses that element throughout the list.
///
///     intersperse(1)([1, 2, 3]) == [1, 1, 2, 1, 3, 1]
public func intersperse<A>(sep : A)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return x +> prependToAll(sep)(l: xs)
	}
}

private func prependToAll<A>(sep : A)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return sep +> x +> prependToAll(sep)(l: xs)
	}
}

/// Transposes the rows and columns of a list.
///
///     transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]
public func transpose<A>(xss : [[A]]) -> [[A]] {
	switch xss.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xss):
			switch x.destruct() {
				case .Empty:
					return transpose(xss)
				case .Destructure(let x, let xs):
					return (x +> concatMap(Array.pure • head)(l: xss)) +> transpose(xs +> concatMap(Array.pure • tail)(l: xss))
			}
	}
}

/// Partitions the elements of a list according to a predicate.
///
/// partition({ $0 < 3 })([1, 2, 3, 4, 5]) == ([1, 2],[3, 4, 5])
public func partition<A>(p : A -> Bool)(l : [A]) -> ([A], [A]) {
	return foldr(select(p))(z: ([], []))(lst: l)
}

private func select<A>(p : A -> Bool)(x : A) -> ([A], [A]) -> ([A], [A]) {
	return { (let t) in
		if p(x) {
			return (x +> t.0, t.1)
		}
		return (t.0, x +> t.1)
	}
}

/// Returns a list of all subsequences of a list.
///
///     subsequences([1, 2, 3]) == [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
public func subsequences<A>(xs : [A]) -> [[A]] {
	return [] +> nonEmptySubsequences(xs)
}

public func nonEmptySubsequences<A>(xs : [A]) -> [[A]] {
	switch xs.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return [x] +> foldr({ (let ys : [A]) in
				return { (let r) in
					return ys +> (x +> ys) +> r
				}
			})(z: [])(lst: nonEmptySubsequences(xs))
	}
}


