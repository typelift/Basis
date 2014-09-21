//
//  Sublists.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Takes, at most, a specified number of elements from a list and returns that sublist.
///
///     take(5)("Hello World!") == "Hello"
///     take(3([1,2]) == [1,2]
///     take(-1)([1,2]) == []
///     take(0)([1,2]) == []
public func take<A>(n : Int)(l : [A]) -> [A] {
	if n <= 0 {
		return []
	}
	
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return x +> take(n - 1)(l: xs)
	}
}

/// Drops, at most, a specified number of elements from a list and returns that sublist.
///
///     drop 6 "Hello World!" == "World!"
///     drop 3 [1,2] == []
///     drop (-1) [1,2] == [1,2]
///     drop 0 [1,2] == [1,2]
public func drop<A>(n : Int)(l : [A]) -> [A] {
	if n <= 0 {
		switch l.destruct() {
			case .Empty:
				return []
			case .Destructure(let x, let xs):
				return xs
		}
	}
	
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return drop(n - 1)(l: xs)
	}
}

/// Returns a tuple containing the first n elements of a list first and the remaining elements 
/// second.
public func splitAt<A>(n : Int)(l : [A]) -> ([A], [A]) {
	return (take(n)(l: l), drop(n)(l: l))
}

/// Returns a list of the first elements that satisfy a predicate until that predicate returns 
/// false.
public func takeWhile<A>(p : A -> Bool)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			if p(x) {
				return x +> takeWhile(p)(l : xs)
			}
			return []
	}
}

/// Returns a list of the first elements that do not satisfy a predicate until that predicate 
/// returns false.
public func dropWhile<A>(p : A -> Bool)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			if p(x) {
				return dropWhile(p)(l : xs)
			}
			return l
	}
}

/// Returns a tuple with the first elements that satisfy a predicate until that predicate returns
/// false first, and a the rest of the elements second.
public func span<A>(p : A -> Bool)(l : [A]) -> ([A], [A]) {
	switch l.destruct() {
		case .Empty:
			return ([], [])
		case .Destructure(let x, let xs):
			if p(x) {
				let (ys, zs) = span(p)(l : xs)
				return (x +> ys, zs)
			}
			return ([], l)
	}
}

/// Returns a tuple with the first elements that do not satisfy a predicate until that predicate 
/// returns false first, and a the rest of the elements second.
public func extreme<A>(p : A -> Bool)(l : [A]) -> ([A], [A]) {
	return span({ ((!) • p)($0) })(l: l)
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other.
public func group<A : Equatable>(xs : [A]) -> [[A]] {
	return groupBy({ $0 == $1 })(l: xs)
}

/// Sorts a list in ascending order.
public func sort<A : Comparable>(xs : [A]) -> [A] {
	return sortBy({ $0 < $1 })(l: xs)
}

/// Takes an element and inserts it into the first position where it is less than or equal to the
/// next element.
///
/// If a value is inserted into a sorted list, the resulting list is also sorted.
public func insert<A : Comparable>(x : A)(l : [A]) -> [A] {
	return insertBy({ $0 <= $1 })(x: x)(l: l)
}

/// Removes duplicates from a list.
public func nub<A : Equatable>(xs : [A]) -> [A] {
	return nubBy({ $0 == $1 })(xs)
}

/// Returns all initial segments of a list.
public func inits<A>(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return [] +> subInits(l)
	}
}

private func subInits<A>(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return map({ x +> $0 })(l: inits(xs))
	}
}

/// Returns all final segments of a list.
public func tails<A>(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return xs +> subTails(l)
	}
}

private func subTails<A>(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return map({ x +> $0 })(l: inits(xs))
	}
}
