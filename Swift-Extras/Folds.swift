//
//  Folds.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: B -> A -> B) (z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return foldl(f)(z: f(z)(x))(lst: xs)
	}
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: (B, A) -> B) (z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return foldl(f)(z: f(z, x))(lst: xs)
	}
}

/// Takes a binary function and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: A -> A -> A)(lst: [A]) -> A {
	switch lst.destruct() {
		case .Destructure(let x, let xs) where xs.count == 0:
			return x
		case .Destructure(let x, let xs):
			return foldl(f)(z: x)(lst: xs)
		case .Empty:
			assert(false, "Cannot invoke foldl1 with an empty list.")
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: (A, A) -> A)(lst: [A]) -> A {
	switch lst.destruct() {
		case .Destructure(let x, let xs) where xs.count == 0:
			return x
		case .Destructure(let x, let xs):
			return foldl(f)(z: x)(lst: xs)
		case .Empty:
			assert(false, "Cannot invoke foldl1 with an empty list.")
	}
}

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: A -> B -> B)(z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return k(x)(foldr(k)(z: z)(lst: xs))
	}
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: (A, B) -> B)(z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return k(x, foldr(k)(z: z)(lst: xs))
	}
}

/// Takes a binary function and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: A -> A -> A)(lst: [A]) -> A {
	switch lst.destruct() {
		case .Destructure(let x, let xs) where xs.count == 0:
			return x
		case .Destructure(let x, let xs):
			return f(x)(foldr1(f)(lst: xs))
		case .Empty:
			assert(false, "Cannot invoke foldr1 with an empty list.")
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: (A, A) -> A)(lst: [A]) -> A {
	switch lst.destruct() {
		case .Destructure(let x, let xs) where xs.count == 0:
			return x
		case .Destructure(let x, let xs):
			return f(x, foldr1(f)(lst: xs))
		case .Empty:
			assert(false, "Cannot invoke foldr1 with an empty list.")
	}
}

/// Returns the conjunction of a Boolean list.
public func and(l : [Bool]) -> Bool {
	return foldr({$0 && $1})(z: true)(lst: l)
}

/// Returns the disjunction of a Boolean list.
public func or(l : [Bool]) -> Bool {
	return foldr({$0 || $1})(z: true)(lst: l)
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied at
/// least once by an element of the list.
public func any<A>(p : A -> Bool)(l : [A]) -> Bool {
	return or(l.map(p))
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
/// all elemenets of the list.
public func all<A>(p : A -> Bool)(l : [A]) -> Bool {
	return and(l.map(p))
}

/// Concatenate a list of lists.
public func concat<A>(xss : [[A]]) -> [A] {
	return foldr({ $0 ++ $1 })(z: [])(lst: xss)
}

/// Map a function over a list and concatenate the results.
public func concatMap<A, B>(f : A -> [B])(l : [A]) -> [B] {
	return foldr({ $1 ++ f($0) })(z: [])(lst: l)
}

/// Returns the maximum value in a list of comparable values.
public func maximum<A : Comparable>(lst : [A]) -> A {
	assert(lst.count != 0, "Cannot maximum foldr1 with an empty list.")

	return foldl1(max)(lst: lst)
}

/// Returns the minimum value in a list of comparable values.
public func minimum<A : Comparable>(lst : [A]) -> A {
	assert(lst.count != 0, "Cannot minimum foldr1 with an empty list.")

	return foldl1(min)(lst: lst)
}


