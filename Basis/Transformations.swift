//
//  Transformations.swift
//  Basis
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Maps a function over a list and returns a new list containing the mapped values.
public func map<A, B>(f : A -> B)(l : [A]) -> [B] {
	return l.map(f)
}

/// Takes a separator and a list and intersperses that element throughout the list.
///
///     intersperse(1)([1, 2, 3]) == [1, 1, 2, 1, 3, 1]
public func intersperse<A>(sep : A) -> [A] -> [A] {
	return { l in
		switch l.destruct() {
			case .Empty:
				return []
			case .Destructure(let x, let xs):
				return x <| prependToAll(sep)(xs)
		}
	}
}

private func prependToAll<A>(sep : A) -> [A] -> [A] {
	return { l in
		switch l.destruct() {
			case .Empty:
				return []
			case .Destructure(let x, let xs):
				return sep <| x <| prependToAll(sep)(xs)
		}
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
					return (x <| concatMap({ [head($0)] })(xss)) <| transpose(xs <| concatMap({ [tail($0)]} )(xss))
			}
	}
}

/// Partitions the elements of a list according to a predicate.
///
/// partition({ $0 < 3 })([1, 2, 3, 4, 5]) == ([1, 2],[3, 4, 5])
public func partition<A>(p : A -> Bool) -> [A] -> ([A], [A]) {
	return { l in foldr(select(p))(([], []))(l) }
}

private func select<A>(p : A -> Bool) -> A -> ([A], [A]) -> ([A], [A]) {
	return { x in { t in p(x) ? (x <| fst(t), snd(t)) : (fst(t), x <| snd(t)) } }
}

/// Returns a list of all subsequences of a list.
///
///     subsequences([1, 2, 3]) == [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
public func subsequences<A>(xs : [A]) -> [[A]] {
	return [] <| nonEmptySubsequences(xs)
}

public func nonEmptySubsequences<A>(xs : [A]) -> [[A]] {
	switch xs.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return [x] <| foldr({ (let ys : [A]) in
				return { r in
					return ys <| (x <| ys) <| r
				}
			})([])(nonEmptySubsequences(xs))
	}
}


