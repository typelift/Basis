//
//  Compare.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Returns whether the two arrays are in ascending order or are equal.
///
/// Arrays are equal when they contain the same elements in the same order.  An array is always
/// larger than the empty array.  If the arrays cannot be determined to have different sizes of
/// elements, the heads of subsequent sub-arrays are compared wtih this ordering predicate until a
/// match is found.
public func <=<T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (match(lhs), match(rhs)) {
		case (.Nil, .Nil):
			return true
		case (.Nil, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Nil):
			return false
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs <= ys) : x <= y
	}
}

/// Returns whether the two arrays are in descending order or are equal.
///
/// Arrays are equal when they contain the same elements in the same order.  An array is always
/// larger than the empty array.  If the arrays cannot be determined to have different sizes of
/// elements, the heads of subsequent sub-arrays are compared wtih this ordering predicate until a
/// match is found.
public func >=<T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (match(lhs), match(rhs)) {
		case (.Nil, .Nil):
			return true
		case (.Nil, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Nil):
			return true
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs >= ys) : x >= y
	}
}

/// Returns whether the two arrays are in ascending order.
public func <<T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (match(lhs), match(rhs)) {
		case (.Nil, .Nil):
			return false
		case (.Nil, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Nil):
			return false
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs < ys) : x < y
	}
}

/// Returns whether the two arrays are in descending order.
public func ><T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (match(lhs), match(rhs)) {
		case (.Nil, .Nil):
			return false
		case (.Nil, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Nil):
			return true
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs > ys) : x > y
	}
}

/// Returns whether the two lists are in ascending order or are equal.
///
/// Lists are equal when they contain the same elements in the same order.  A list is always
/// larger than the empty list.  If the arrays cannot be determined to have different sizes of
/// elements, the heads of subsequent sub-lists are compared wtih this ordering predicate until a
/// match is found.
public func <=<T : Comparable>(lhs: List<T>, rhs: List<T>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return true
		case (.Nil, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Nil):
			return false
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs <= ys) : x <= y
	}
}

/// Returns whether the two arrays are in descending order or are equal.
///
/// Lists are equal when they contain the same elements in the same order.  A list is always
/// larger than the empty list.  If the arrays cannot be determined to have different sizes of
/// elements, the heads of subsequent sub-lists are compared wtih this ordering predicate until a
/// match is found.
public func >=<T : Comparable>(lhs: List<T>, rhs: List<T>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return true
		case (.Nil, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Nil):
			return true
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs >= ys) : x >= y
	}
}

/// Returns whether the two lists are in ascending order.
public func <<T : Comparable>(lhs: List<T>, rhs: List<T>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return false
		case (.Nil, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Nil):
			return false
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs < ys) : x < y
	}
}

/// Returns whether the two lists are in descending order.
public func ><T : Comparable>(lhs: List<T>, rhs: List<T>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return false
		case (.Nil, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Nil):
			return true
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs > ys) : x > y
	}
}

/// Maps an argument into a comparable form for use with the xxxBy functions.
///
///
///     let x = [(2, 3), (1, 4), (4, 2), (5, 1), (3, 5)]
///     
///     sortBy(comparing(fst))(x) = [(1, 4), (2, 3), (3, 5), (4, 2), (5, 1)]
///     sortBy(comparing(snd))(x) = [(5, 1), (4, 2), (2, 3), (1, 4), (3, 5)]
public func comparing<A : Comparable, B>(p : B -> A) -> B -> B -> Bool {
	return { x in { y in p(x) < p(y) } }
}

/// Takes an array and groups its elements into sublists of duplicate elements found next to each
/// other according to an equality predicate.
public func groupBy<A>(cmp : A -> A -> Bool) -> [A] -> [[A]] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				let (ys, zs) = span(cmp(x))(xs)
				return (x <<| ys) <<| groupBy(cmp)(zs)
		}
	}
}

/// Takes an array and groups its elements into sublists of duplicate elements found next to each
/// other according to an equality operator.
public func groupBy<A>(cmp : (A, A) -> Bool) -> [A] -> [[A]] {
	return { l in
		switch match(l) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				let (ys, zs) = span({ cmp(x, $0) })(xs)
				return (x <<| ys) <<| groupBy(cmp)(zs)
		}
	}
}

/// Takes a list and groups its elements into sublists of duplicate elements found next to each
/// other according to an equality predicate.
public func groupBy<A>(cmp : A -> A -> Bool) -> List<A> -> List<List<A>>  {
	return { l in
		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				let (ys, zs) = span(cmp(x))(xs)
				return (x <<| ys) <<| groupBy(cmp)(zs)
		}
	}
}

/// Takes a list and groups its elements into sublists of duplicate elements found next to each
/// other according to an equality operator.
public func groupBy<A>(cmp : (A, A) -> Bool) -> List<A> -> List<List<A>> {
	return { l in
		switch l.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				let (ys, zs) = span({ cmp(x, $0) })(xs)
				return (x <<| ys) <<| groupBy(cmp)(zs)
		}
	}
}

/// Removes duplicates from an array according to an equality predicate.
public func nubBy<A>(eq : A -> A -> Bool) -> [A] -> [A] {
	return { lst in
		switch match(lst) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ y in
					return !(eq(x)(y))
				}))
		}
	}
}

/// Removes duplicates from an array according to an equality operator.
public func nubBy<A>(eq : (A, A) -> Bool) -> [A] -> [A] {
	return { lst in
		switch match(lst) {
			case .Nil:
				return []
			case .Cons(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ y in
					return !(eq(x, y))
				}))
		}
	}
}

/// Removes duplicates from a list according to an equality predicate.
public func nubBy<A>(eq : A -> A -> Bool) -> List<A> -> List<A> {
	return { lst in
		switch lst.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				return List(x) + nubBy(eq)(xs.filter({ y in
					return !(eq(x)(y))
				}))
		}
	}
}

/// Removes duplicates from a list according to an equality operator.
public func nubBy<A>(eq : (A, A) -> Bool) -> List<A> -> List<A> {
	return { lst in
		switch lst.match() {
			case .Nil:
				return List()
			case .Cons(let x, let xs):
				return List(x) + nubBy(eq)(xs.filter({ y in
					return !(eq(x, y))
				}))
		}
	}
}

/// Sorts an array according to a ordering predicate.
public func sortBy<A>(cmp : A -> A -> Bool) -> [A] -> [A] {
	return { l in foldr(insertBy(cmp))([])(l) }
}

/// Sorts an array according to an ordering operator.
public func sortBy<A>(cmp : (A, A) -> Bool) -> [A] -> [A] {
	return { l in foldr(insertBy(cmp))([])(l) }
}

/// Sorts a list according to a ordering predicate.
public func sortBy<A>(cmp : A -> A -> Bool) -> List<A> -> List<A> {
	return { l in foldr(insertBy(cmp))(List())(l) }
}

/// Sorts a list according to an ordering operator.
public func sortBy<A>(cmp : (A, A) -> Bool) -> List<A> -> List<A> {
	return { l in foldr(insertBy(cmp))(List())(l) }
}


/// Inserts an element into an array according to an ordering predicate.
public func insertBy<A>(cmp: A -> A -> Bool) -> A -> [A] -> [A] {
	return { x in { l in
		switch match(l) {
			case .Nil:
				return [x]
			case .Cons(let y, let ys):
				return cmp(x)(y) ? (x <<| l) : (y <<| insertBy(cmp)(x)(ys))
		}
	} }
}

/// Inserts an element into an array according to an ordering operator.
public func insertBy<A>(cmp: (A, A) -> Bool) -> A -> [A] -> [A] {
	return { x in { l in
		switch match(l) {
			case .Nil:
				return [x]
			case .Cons(let y, let ys):
				return cmp(x, y) ? (x <<| l) : (y <<| insertBy(cmp)(x)(ys))
		}
	} }
}

/// Inserts an element into a list according to an ordering predicate.
public func insertBy<A>(cmp: A -> A -> Bool) -> A -> List<A> -> List<A> {
	return { x in { l in
		switch l.match() {
			case .Nil:
				return List(x)
			case .Cons(let y, let ys):
				return cmp(x)(y) ? (x <<| l) : (y <<| insertBy(cmp)(x)(ys))
		}
	} }
}

/// Inserts an element into a list according to an ordering operator.
public func insertBy<A>(cmp: (A, A) -> Bool) -> A -> List<A> -> List<A> {
	return { x in { l in
		switch l.match() {
			case .Nil:
				return List(x)
			case .Cons(let y, let ys):
				return cmp(x, y) ? (x <<| l) : (y <<| insertBy(cmp)(x)(ys))
		}
	} }
}

/// Returns the maximum element of an array according to an ordering predicate.
public func maximumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return { l in
		switch match(l) {
			case .Nil:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t))(snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the maximum element of an array according to an ordering operator.
public func maximumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return { l in
		switch match(l) {
			case .Nil:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t), snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the maximum element of a list according to an ordering predicate.
public func maximumBy<A>(cmp : A -> A -> Bool) -> List<A> -> A {
	return { l in
		switch l.match() {
			case .Nil:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t))(snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the maximum element of a list according to an ordering operator.
public func maximumBy<A>(cmp : (A, A) -> Bool) -> List<A> -> A {
	return { l in
		switch l.match() {
			case .Nil:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t), snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the minimum element of an array according to an ordering predicate.
public func minimumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return { l in
		switch match(l) {
			case .Nil:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t))(snd(t)) ? snd(t) :  fst(t)
				})(l)
		}
	}
}

/// Returns the minimum element of an array according to an ordering operator.
public func minimumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return { l in
		switch match(l) {
			case .Nil:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t), snd(t)) ? snd(t) : fst(t)
				})(l)
		}
	}
}

/// Returns the minimum element of a list according to an ordering predicate.
public func minimumBy<A>(cmp : A -> A -> Bool) -> List<A> -> A {
	return { l in
		switch l.match() {
			case .Nil:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t))(snd(t)) ? snd(t) :  fst(t)
				})(l)
		}
	}
}

/// Returns the minimum element of a list according to an ordering operator.
public func minimumBy<A>(cmp : (A, A) -> Bool) -> List<A> -> A {
	return { l in
		switch l.match() {
			case .Nil:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ t in
					return cmp(fst(t), snd(t)) ? snd(t) : fst(t)
				})(l)
		}
	}
}

