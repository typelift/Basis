//
//  Folds.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: B -> A -> B) -> B -> [A] -> B {
	return { z in { l in
		switch l.destruct() {
			case .Empty:
				return z
			case .Destructure(let x, let xs):
				return foldl(f)(f(z)(x))(xs)
		}
	} }
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: (B, A) -> B) -> B -> [A] -> B {
	return { z in { l in
		switch l.destruct() {
			case .Empty:
				return z
			case .Destructure(let x, let xs):
				return foldl(f)(f(z, x))(xs)
		}
	} }
}

/// Takes a binary function and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: A -> A -> A) -> [A] -> A {
	return { l in
		switch l.destruct() {
			case .Destructure(let x, let xs) where xs.count == 0:
				return x
			case .Destructure(let x, let xs):
				return foldl(f)(x)(xs)
			case .Empty:
				assert(false, "Cannot invoke foldl1 with an empty list.")
		}
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: (A, A) -> A) -> [A] -> A {
	return { l in
		switch l.destruct() {
			case .Destructure(let x, let xs) where xs.count == 0:
				return x
			case .Destructure(let x, let xs):
				return foldl(f)(x)(xs)
			case .Empty:
				assert(false, "Cannot invoke foldl1 with an empty list.")
		}
	}
}

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: A -> B -> B) -> B -> [A] -> B {
	return { z in { l in
		switch l.destruct() {
			case .Empty:
				return z
			case .Destructure(let x, let xs):
				return k(x)(foldr(k)(z)(xs))
		}
	} }
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: (A, B) -> B) -> B -> [A] -> B {
	return { z in { l in
		switch l.destruct() {
			case .Empty:
				return z
			case .Destructure(let x, let xs):
				return k(x, foldr(k)(z)(xs))
		}
	} }
}

/// Takes a binary function and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: A -> A -> A) -> [A] -> A {
	return { l in
		switch l.destruct() {
			case .Destructure(let x, let xs) where xs.count == 0:
				return x
			case .Destructure(let x, let xs):
				return f(x)(foldr1(f)(xs))
			case .Empty:
				assert(false, "Cannot invoke foldr1 with an empty list.")
		}
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: (A, A) -> A) -> [A] -> A {
	return { l in
		switch l.destruct() {
			case .Destructure(let x, let xs) where xs.count == 0:
				return x
			case .Destructure(let x, let xs):
				return f(x, foldr1(f)(xs))
			case .Empty:
				assert(false, "Cannot invoke foldr1 with an empty list.")
		}
	}
}

/// Returns the conjunction of a Boolean list.
public func and(l : [Bool]) -> Bool {
	return foldr({$0 && $1})(true)(l)
}

/// Returns the disjunction of a Boolean list.
public func or(l : [Bool]) -> Bool {
	return foldr({$0 || $1})(true)(l)
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied at
/// least once by an element of the list.
public func any<A>(p : A -> Bool) -> [A] -> Bool {
	return { l in or(l.map(p)) }
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
/// all elemenets of the list.
public func all<A>(p : A -> Bool) -> [A] -> Bool {
	return { l in and(l.map(p)) }
}

/// Concatenate a list of lists.
public func concat<A>(xss : [[A]]) -> [A] {
	return foldr({ $0 + $1 })([])(xss)
}

/// Map a function over a list and concatenate the results.
public func concatMap<A, B>(f : A -> [B]) -> [A] -> [B] {
	return { l in foldr({ f($0) + $1 })([])(l) }
}

/// Returns the maximum value in a list of comparable values.
public func maximum<A : Comparable>(l : [A]) -> A {
	assert(l.count != 0, "Cannot find the maximum value of an empty list.")

	return foldl1(max)(l)
}

/// Returns the minimum value in a list of comparable values.
public func minimum<A : Comparable>(l : [A]) -> A {
	assert(l.count != 0, "Cannot find the minimum value of an empty list.")

	return foldl1(min)(l)
}

/// Returns the sum of a list of numbers.
public func sum<N : IntegerType>(l : [N]) -> N {
	return foldl({ $0 + $1 })(0)(l)
}

/// Returns the product of a list of numbers.
public func product<N : IntegerType>(l : [N]) -> N {
	return foldl({ $0 * $1 })(1)(l)
}


