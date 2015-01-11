//
//  Sublists.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Takes, at most, a specified number of elements from an array and returns that sublist.
///
///     take(5)("Hello World!") == "Hello"
///     take(3([1,2]) == [1,2]
///     take(-1)([1,2]) == []
///     take(0)([1,2]) == []
public func take<A>(n : Int) -> [A] -> [A] {
	return { l in
		if n <= 0 {
			return []
		}
		
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return x <| take(n - 1)(xs)
		}
	}
}

/// Drops, at most, a specified number of elements from an array and returns that sublist.
///
///     drop 6 "Hello World!" == "World!"
///     drop 3 [1,2] == []
///     drop (-1) [1,2] == [1,2]
///     drop 0 [1,2] == [1,2]
public func drop<A>(n : Int) -> [A] -> [A] {
	return { l in
		if n <= 0 {
			return l
		}
		
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return drop(n - 1)(xs)
		}
	}
}

/// Takes, at most, a specified number of elements from a list and returns that sublist.
///
///     take(5)("Hello World!") == "Hello"
///     take(3([1,2]) == [1,2]
///     take(-1)([1,2]) == []
///     take(0)([1,2]) == []
public func take<A>(n : Int) -> List<A> -> List<A> {
	return { l in
		if n <= 0 {
			return List()
		}

		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				return x <| take(n - 1)(xs)
		}
	}
}

/// Drops, at most, a specified number of elements from a list and returns that sublist.
///
///     drop 6 "Hello World!" == "World!"
///     drop 3 [1,2] == []
///     drop (-1) [1,2] == [1,2]
///     drop 0 [1,2] == [1,2]
public func drop<A>(n : Int) -> List<A> -> List<A> {
	return { l in
		if n <= 0 {
			return l
		}

		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				return drop(n - 1)(xs)
		}
	}
}


/// Returns a tuple containing the first n elements of an array first and the remaining elements
/// second.
public func splitAt<A>(n : Int) -> [A] -> ([A], [A]) {
	return { l in (take(n)(l), drop(n)(l)) }
}

/// Returns a tuple containing the first n elements of an array first and the remaining elements
/// second.
public func splitAt<A>(n : Int) -> List<A> -> (List<A>, List<A>) {
	return { l in (take(n)(l), drop(n)(l)) }
}

/// Returns an array of the first elements that satisfy a predicate until that predicate returns
/// false.
public func takeWhile<A>(p : A -> Bool) -> [A] -> [A] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				if p(x) {
					return x <| takeWhile(p)(xs)
				}
				return []
		}
	}
}

/// Returns an array of the first elements that do not satisfy a predicate until that predicate
/// returns false.
public func dropWhile<A>(p : A -> Bool) -> [A] -> [A] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				if p(x) {
					return dropWhile(p)(xs)
				}
				return l
		}
	}
}

/// Returns a list of the first elements that satisfy a predicate until that predicate returns
/// false.
public func takeWhile<A>(p : A -> Bool) -> List<A> -> List<A> {
	return { l in
		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				if p(x) {
					return x <| takeWhile(p)(xs)
				}
				return List()
		}
	}
}

/// Returns a list of the first elements that do not satisfy a predicate until that predicate
/// returns false.
public func dropWhile<A>(p : A -> Bool) -> List<A> -> List<A> {
	return { l in
		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				if p(x) {
					return dropWhile(p)(xs)
				}
				return l
		}
	}
}

/// Returns a tuple with the first elements that satisfy a predicate until that predicate returns
/// false first, and a the rest of the elements second.
public func span<A>(p : A -> Bool) -> [A] -> ([A], [A]) {
	return { l in
		switch match(l) {
			case .Nil:
				return ([], [])
			case .Cons(let x, let xs):
				if p(x) {
					let (ys, zs) = span(p)(xs)
					return (x <| ys, zs)
				}
				return ([], l)
		}
	}
}

/// Returns a tuple with the first elements that do not satisfy a predicate until that predicate 
/// returns false first, and a the rest of the elements second.
public func extreme<A>(p : A -> Bool) -> [A] -> ([A], [A]) {
	return { l in span({ ((!) • p)($0) })(l) }
}

/// Returns a tuple with the first elements that satisfy a predicate until that predicate returns
/// false first, and a the rest of the elements second.
public func span<A>(p : A -> Bool) -> List<A> -> (List<A>, List<A>) {
	return { l in
		switch l.match() {
			case .Nil:
				return (List(), List())
			case .Cons(let x, let xs):
				if p(x) {
					let (ys, zs) = span(p)(xs)
					return (x <| ys, zs)
				}
				return (List(), l)
		}
	}
}

/// Returns a tuple with the first elements that do not satisfy a predicate until that predicate
/// returns false first, and a the rest of the elements second.
public func extreme<A>(p : A -> Bool) -> List<A> -> (List<A>, List<A>) {
	return { l in span({ ((!) • p)($0) })(l) }
}

/// Takes an array and groups its arguments into sublists of duplicate elements found next to each
/// other.
public func group<A : Equatable>(xs : [A]) -> [[A]] {
	return groupBy({ $0 == $1 })(xs)
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other.
public func group<A : Equatable>(xs : List<A>) -> List<List<A>> {
	return groupBy({ $0 == $1 })(xs)
}

/// Sorts an array in ascending order.
public func sort<A : Comparable>(xs : [A]) -> [A] {
	return sortBy({ $0 < $1 })(xs)
}

/// Sorts a list in ascending order.
public func sort<A : Comparable>(xs : List<A>) -> List<A> {
	return sortBy({ $0 < $1 })(xs)
}

/// Takes an element and inserts it into the first position where it is less than or equal to the
/// next element.
///
/// If a value is inserted into a sorted array, the resulting array is also sorted.
public func insert<A : Comparable>(x : A) -> [A] -> [A] {
	return { l in insertBy({ $0 <= $1 })(x)(l) }
}

/// Takes an element and inserts it into the first position where it is less than or equal to the
/// next element.
///
/// If a value is inserted into a sorted list, the resulting list is also sorted.
public func insert<A : Comparable>(x : A) -> List<A> -> List<A> {
	return { l in insertBy({ $0 <= $1 })(x)(l) }
}

/// Removes duplicates from an array.
public func nub<A : Equatable>(xs : [A]) -> [A] {
	return nubBy({ $0 == $1 })(xs)
}

/// Removes duplicates from a list.
public func nub<A : Equatable>(xs : List<A>) -> List<A> {
	return nubBy({ $0 == $1 })(xs)
}

/// Returns all initial segments of an array.
public func inits<A>(l : [A]) -> [[A]] {	
	return foldr({ x, xss in
		return [] <| map({ x <| $0 })(xss)
	})([[]])(l)
}

/// Returns all final segments of an array.
public func tails<A>(l : [A]) -> [[A]] {
	return foldr({ x, y in
		return (x <| head(y)) <| y
	})([[]])(l)
}

/// Returns all initial segments of a list.
public func inits<A>(l : List<A>) -> List<List<A>> {
	return foldr({ x, xss in
		return List() <| xss.map({ x <| $0 })
	})(List<List<A>>())(l)
}

/// Returns all final segments of a list.
public func tails<A>(l : List<A>) -> List<List<A>> {
	return foldr({ x, y in
		return (x <| head(y)) <| y
	})(List<List<A>>())(l)
}
