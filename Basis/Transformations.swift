//
//  Transformations.swift
//  Basis
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Maps a function over a list and returns a new list containing the mapped values.
public func map<A, B>(f : A -> B) -> [A] -> [B] {
	return { l in l.map(f) }
}

/// Replace all occurrences of a value in a list by another value.
public func replace<A : Equatable>(x : A) -> A -> [A] -> [A] {
	return { y in { xs in xs.map({ z in z == x ? y : z }) } }
}

/// Takes a separator and a list and intersperses that element throughout the list.
///
///     intersperse(1)([1, 2, 3]) == [1, 1, 2, 1, 3, 1]
public func intersperse<A>(sep : A) -> [A] -> [A] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return x <| prependToAll(sep)(xs)
		}
	}
}

private func prependToAll<A>(sep : A) -> [A] -> [A] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return sep <| x <| prependToAll(sep)(xs)
		}
	}
}

/// Inserts a list in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(xs : [A]) -> [[A]] -> [A] {
	return { xss in concat(intersperse(xs)(xss)) }
}

/// Transposes the rows and columns of a list.
///
///     transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]
public func transpose<A>(xss : [[A]]) -> [[A]] {
	switch match(xss) {
		case .Nil:
			return []
		case .Cons(let x, let xss):
			switch match(x) {
				case .Nil:
					return transpose(xss)
				case .Cons(let x, let xs):
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
	switch match(xs) {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			return [x] <| foldr({ (let ys : [A]) in
				return { r in
					return ys <| (x <| ys) <| r
				}
			})([])(nonEmptySubsequences(xs))
	}
}


