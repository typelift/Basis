//
//  Transformations.swift
//  Basis
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Maps a function over an array and returns a new array containing the mapped values.
public func map<A, B>(_ f : @escaping (A) -> B) -> ([A]) -> [B] {
	return { l in l.map(f) }
}

/// Maps a function over a list and returns a new list containing the mapped values.
public func map<A, B>(_ f : @escaping (A) -> B) -> (List<A>) -> List<B> {
	return { l in l.map(f) }
}

/// Replace all occurrences of a value in an array by another value.
public func replace<A : Equatable>(_ x : A) -> (A) -> ([A]) -> [A] {
	return { y in { xs in xs.map({ z in z == x ? y : z }) } }
}

/// Replace all occurrences of a value in a list by another value.
public func replace<A : Equatable>(_ x : A) -> (A) -> (List<A>) -> List<A> {
	return { y in { xs in xs.map({ z in z == x ? y : z }) } }
}

/// Takes a separator and an array and intersperses that element throughout the array.
///
///     intersperse(1)([1, 2, 3]) == [1, 1, 2, 1, 3, 1]
public func intersperse<A>(_ sep : A) -> ([A]) -> [A] {
	return { l in
		switch match(l) {
			case .nil:
				return []
			case .cons(let x, let xs):
				return x <<| prependToAll(sep)(xs)
		}
	}
}

private func prependToAll<A>(_ sep : A) -> ([A]) -> [A] {
	return { l in
		switch match(l) {
			case .nil:
				return []
			case .cons(let x, let xs):
				return sep <<| (x <<| prependToAll(sep)(xs))
		}
	}
}

/// Takes a separator and a list and intersperses that element throughout the list.
///
///     intersperse(1)([1, 2, 3]) == [1, 1, 2, 1, 3, 1]
public func intersperse<A>(_ sep : A) -> (List<A>) -> List<A> {
	return { l in
		switch l.match() {
			case .nil:
				return List()
			case .cons(let x, let xs):
				return x <<| prependToAll(sep)(xs)
		}
	}
}

private func prependToAll<A>(_ sep : A) -> (List<A>) -> List<A> {
	return { l in
		switch l.match() {
			case .nil:
				return List()
			case .cons(let x, let xs):
				return sep <<| (x <<| prependToAll(sep)(xs))
		}
	}
}

/// Inserts an array in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(_ xs : [A]) -> ([[A]]) -> [A] {
	return { xss in concat(intersperse(xs)(xss)) }
}

/// Inserts a list in between the elements of a 2-dimensional list and concatenates the result.
public func intercalate<A>(_ xs : List<A>) -> (List<List<A>>) -> List<A> {
	return { xss in concat(intersperse(xs)(xss)) }
}

/// Transposes the rows and columns of a 2-dimensional array.
///
///     transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]
public func transpose<A>(_ xss : [[A]]) -> [[A]] {
	switch match(xss) {
		case .nil:
			return []
		case .cons(let x, let xss):
			switch match(x) {
				case .nil:
					return transpose(xss)
				case .cons(let x, let xs):
					return (x <<| concatMap({ [head($0)] })(xss)) <<| transpose(xs <<| concatMap({ [tail($0)] })(xss))
			}
	}
}

/// Transposes the rows and columns of a 2-dimensional list.
///
///     transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]
public func transpose<A>(_ xss : List<List<A>>) -> List<List<A>> {
	switch xss.match() {
	case .nil:
		return List()
	case .cons(let x, let xss):
		switch x.match() {
			case .nil:
				return transpose(xss)
			case .cons(let x, let xs):
				return (x <<| concatMap({ List(head($0)) })(xss)) <<| transpose(xs <<| concatMap({ List(tail($0)) })(xss))
		}
	}
}

/// Partitions the elements of an array according to a predicate.
///
/// partition({ $0 < 3 })([1, 2, 3, 4, 5]) == ([1, 2],[3, 4, 5])
public func partition<A>(_ p : @escaping (A) -> Bool) -> ([A]) -> ([A], [A]) {
	return { l in foldr(thunk(select(p)))(([], []))(l) }
}

private func select<A>(_ p : @escaping (A) -> Bool) -> (A) -> ([A], [A]) -> ([A], [A]) {
	return { x in { t1, t2 in p(x) ? (x <<| t1, t2) : (t1, x <<| t2) } }
}

/// Partitions the elements of a list according to a predicate.
///
/// partition({ $0 < 3 })([1, 2, 3, 4, 5]) == ([1, 2],[3, 4, 5])
public func partition<A>(_ p : @escaping (A) -> Bool) -> (List<A>) -> (List<A>, List<A>) {
	let e = (List<A>(), List<A>())
	return { l in foldr(thunk(select(p)))(e)(l) }
}

private func thunk<A, B, C, D>(_ f : @escaping (A) -> (B, C) -> D) -> (A) -> ((B, C)) -> D {
  return { h in { g in f(h)(g.0, g.1) } }
}

private func select<A>(_ p : @escaping (A) -> Bool) -> (A) -> (List<A>, List<A>) -> (List<A>, List<A>) {
	return { x in { t1, t2 in p(x) ? (x <<| t1, t2) : (t1, x <<| t2) } }
}

/// Returns an array of all subsequences of an array.
///
///     subsequences([1, 2, 3]) == [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
public func subsequences<A>(_ xs : [A]) -> [[A]] {
	return [] <<| nonEmptySubsequences(xs)
}

public func nonEmptySubsequences<A>(_ xs : [A]) -> [[A]] {
	switch match(xs) {
		case .nil:
			return []
		case .cons(let x, let xs):
			return [x] <<| foldr({ ys, r in
				return ys <<| ((x <<| ys) <<| r)
		})([])(nonEmptySubsequences(xs))
	}
}

/// Returns a list of all subsequences of a list.
///
///     subsequences([1, 2, 3]) == [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
public func subsequences<A>(_ xs : List<A>) -> List<List<A>> {
	return List() <<| nonEmptySubsequences(xs)
}

public func nonEmptySubsequences<A>(_ xs : List<A>) -> List<List<A>> {
	switch xs.match() {
		case .nil:
			return List()
		case .cons(let x, let xs):
			return List(x) <<| foldr({ ys, r in
				return ys <<| ((x <<| ys) <<| r)
			})(List())(nonEmptySubsequences(xs))
	}
}


