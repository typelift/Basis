//
//  Scans.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Takes a binary function, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the left to the right.
/// 
///     scanl(f)(z)([x1, x2, ...]) == [z, f(z, x1), f(f(z, x1), x2), ...]
public func scanl<B, A>(f : B -> A -> B)(q : B)(ls : [A]) -> [B] {
	switch ls.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: f(q)(x))(ls: xs)
	}
}

/// Takes a binary operator, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the left to the right.
/// 
///     scanl(f)(z)([x1, x2, ...]) == [z, f(z, x1), f(f(z, x1), x2), ...]
public func scanl<B, A>(f : (B, A) -> B)(q : B)(ls : [A]) -> [B] {
	switch ls.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: f(q, x))(ls: xs)
	}
}

/// Takes a binary function and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// left to the right.
public func scanl1<A>(f : A -> A -> A)(l: [A]) -> [A]{
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: x)(ls: xs)
	}
}

/// Takes a binary operator and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// left to the right.
public func scanl1<A>(f : (A, A) -> A)(l: [A]) -> [A]{
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: x)(ls: xs)
	}
}

/// Takes a binary function, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the right to the left.
/// 
///     scanr(f)(z)([x1, x2, ...]) == [..., f(f(z, x1), x2), f(z, x1), z]
public func scanr<B, A>(f : A -> B -> B)(q : B)(ls : [A]) -> [B] {
	switch ls.destruct() {
		case .Empty:
			return [q]
		case .Destructure(let x, let xs):
			return f(x)(q) +> scanr(f)(q: q)(ls: xs)
	}
}

/// Takes a binary operator, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the right to the left.
/// 
///     scanr(f)(z)([x1, x2, ...]) == [..., f(f(z, x1), x2), f(z, x1), z]
public func scanr<B, A>(f : (A, B) -> B)(q : B)(ls : [A]) -> [B] {
	switch ls.destruct() {
		case .Empty:
			return [q]
		case .Destructure(let x, let xs):
			return f(x, q) +> scanr(f)(q: q)(ls: xs)
	}
}

/// Takes a binary function and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// right to the left.
public func scanr1<A>(f : A -> A -> A)(l: [A]) -> [A]{
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs) where xs.count == 0:
			return [x]
		case .Destructure(let x, let xs):
			let qs = scanr1(f)(l: xs)
			switch qs.destruct() {
				case .Empty:
					assert(false, "")
				case .Destructure(let q, _):
					return f(x)(q) +> qs
		}
	}
}

/// Takes a binary operator and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// right to the left.
public func scanr1<A>(f : (A, A) -> A)(l: [A]) -> [A]{
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs) where xs.count == 0:
			return [x]
		case .Destructure(let x, let xs):
			let qs = scanr1(f)(l: xs)
			switch qs.destruct() {
				case .Empty:
					assert(false, "")
				case .Destructure(let q, _):
					return f(x, q) +> qs
			}
	}
}

