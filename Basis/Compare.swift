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
	switch (destruct(lhs), destruct(rhs)) {
		case (.Empty, .Empty):
			return true
		case (.Empty, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Empty):
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
	switch (destruct(lhs), destruct(rhs)) {
		case (.Empty, .Empty):
			return true
		case (.Empty, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Empty):
			return true
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs >= ys) : x >= y
	}
}

/// Returns whether the two arrays are in ascending order.
public func <<T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (destruct(lhs), destruct(rhs)) {
		case (.Empty, .Empty):
			return false
		case (.Empty, .Cons(_, _)):
			return true
		case (.Cons(_, _), .Empty):
			return false
		case (.Cons(let x, let xs), .Cons(let y, let ys)):
			return (x == y) ? (xs < ys) : x < y
	}
}

/// Returns whether the two arrays are in descending order.
public func ><T : Comparable>(lhs: [T], rhs: [T]) -> Bool {
	switch (destruct(lhs), destruct(rhs)) {
		case (.Empty, .Empty):
			return false
		case (.Empty, .Cons(_, _)):
			return false
		case (.Cons(_, _), .Empty):
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

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other according to an equality predicate.
public func groupBy<A>(cmp : A -> A -> Bool) -> [A] -> [[A]] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs):
				let (ys, zs) = span(cmp(x))(xs)
				return (x <| ys) <| groupBy(cmp)(zs)
		}
	}
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other according to an equality operator.
public func groupBy<A>(cmp : (A, A) -> Bool) -> [A] -> [[A]] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs):
				let (ys, zs) = span({ cmp(x, $0) })(xs)
				return (x <| ys) <| groupBy(cmp)(zs)
		}
	}
}

/// Removes duplicates from a list according to an equality predicate.
public func nubBy<A>(eq : A -> A -> Bool) -> [A] -> [A] {
	return { lst in
		switch destruct(lst) {
			case .Empty():
				return []
			case .Cons(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ y in
					return !(eq(x)(y))
				}))
		}
	}
}

/// Removes duplicates from a list according to an equality operator.
public func nubBy<A>(eq : (A, A) -> Bool) -> [A] -> [A] {
	return { lst in
		switch destruct(lst) {
			case .Empty():
				return []
			case .Cons(let x, let xs):
				return [x] + nubBy(eq)(xs.filter({ y in
					return !(eq(x, y))
				}))
		}
	}
}

/// Sorts a list according to a ordering predicate.
public func sortBy<A>(cmp : A -> A -> Bool) -> [A] -> [A] {
	return { l in foldr(insertBy(cmp))([])(l) }
}

/// Sorts a list according to an ordering operator.
public func sortBy<A>(cmp : (A, A) -> Bool) -> [A] -> [A] {
	return { l in foldr(insertBy(cmp))([])(l) }
}

/// Inserts an element into a list according to an ordering predicate.
public func insertBy<A>(cmp: A -> A -> Bool) -> A -> [A] -> [A] {
	return { x in { l in
		switch destruct(l) {
			case .Empty:
				return [x]
			case .Cons(let y, let ys):
				return cmp(x)(y) ? x <| l : y <| insertBy(cmp)(x)(ys)
		}
	} }
}

/// Inserts an element into a list according to an ordering operator.
public func insertBy<A>(cmp: (A, A) -> Bool) -> A -> [A] -> [A] {
	return { x in { l in
		switch destruct(l) {
			case .Empty:
				return [x]
			case .Cons(let y, let ys):
				return cmp(x, y) ?  x <| l : y <| insertBy(cmp)(x)(ys)
		}
	} }
}

/// Returns the maximum element of a list according to an ordering predicate.
public func maximumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return { l in
		switch destruct(l) {
			case .Empty:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ (let t) -> A in
					return cmp(fst(t))(snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the maximum element of a list according to an ordering operator.
public func maximumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return { l in
		switch destruct(l) {
			case .Empty:
				fatalError("Cannot find the maximum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ (let t) -> A in
					return cmp(fst(t), snd(t)) ? fst(t) : snd(t)
				})(l)
		}
	}
}

/// Returns the minimum element of a list according to an ordering predicate.
public func minimumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return { l in
		switch destruct(l) {
			case .Empty:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ (let t) -> A in
					return cmp(fst(t))(snd(t)) ? snd(t) :  fst(t)
				})(l)
		}
	}
}

/// Returns the minimum element of a list according to an ordering operator.
public func minimumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return { l in
		switch destruct(l) {
			case .Empty:
				fatalError("Cannot find the minimum element of an empty list.")
			case .Cons(_, _):
				return foldl1({ (let t) -> A in
					return cmp(fst(t), snd(t)) ? snd(t) : fst(t)
				})(l)
		}
	}
}

