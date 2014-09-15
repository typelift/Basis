//
//  Sublists.swift
//  Swift_Extras
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
