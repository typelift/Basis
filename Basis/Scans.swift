//
//  Scans.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Takes a binary function, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the left to the right.
/// 
///     scanl(f)(z)([x1, x2, ...]) == [z, f(z, x1), f(f(z, x1), x2), ...]
public func scanl<B, A>(f : B -> A -> B) -> B -> [A] -> [B] {
	return { q in { ls in
		switch destruct(ls) {
			case .Empty:
				return q <| []
			case .Cons(let x, let xs):
				return q <| scanl(f)(f(q)(x))(xs)
		}
	} }
}

/// Takes a binary operator, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the left to the right.
/// 
///     scanl(f)(z)([x1, x2, ...]) == [z, f(z, x1), f(f(z, x1), x2), ...]
public func scanl<B, A>(f : (B, A) -> B) -> B -> [A] -> [B] {
	return { q in { ls in
		switch destruct(ls) {
			case .Empty:
				return q <| []
			case .Cons(let x, let xs):
				return q <| scanl(f)(f(q, x))(xs)
		}
	} }
}

/// Takes a binary function and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// left to the right.
public func scanl1<A>(f : A -> A -> A) -> [A] -> [A] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs):
				return scanl(f)(x)(xs)
		}
	}
}

/// Takes a binary operator and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// left to the right.
public func scanl1<A>(f : (A, A) -> A) -> [A] -> [A] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs):
				return scanl(f)(x)(xs)
		}
	}
}

/// Takes a binary function, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the right to the left.
/// 
///     scanr(f)(z)([x1, x2, ...]) == [..., f(f(z, x1), x2), f(z, x1), z]
public func scanr<B, A>(f : A -> B -> B) -> B -> [A] -> [B] {
	return { q in { ls in
		switch destruct(ls) {
			case .Empty:
				return [q]
			case .Cons(let x, let xs):
				return f(x)(q) <| scanr(f)(q)(xs)
		}
	} }
}

/// Takes a binary operator, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from 
/// the right to the left.
/// 
///     scanr(f)(z)([x1, x2, ...]) == [..., f(f(z, x1), x2), f(z, x1), z]
public func scanr<B, A>(f : (A, B) -> B) -> B -> [A] -> [B] {
	return { q in { ls in
		switch destruct(ls) {
			case .Empty:
				return [q]
			case .Cons(let x, let xs):
				return f(x, q) <| scanr(f)(q)(xs)
		}
	} }
}

/// Takes a binary function and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// right to the left.
public func scanr1<A>(f : A -> A -> A) -> [A] -> [A] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs) where xs.count == 0:
				return [x]
			case .Cons(let x, let xs):
				let qs = scanr1(f)(xs)
				switch destruct(qs) {
					case .Empty:
						fatalError("Cannot scanr1 across an empty list.")
					case .Cons(let q, _):
						return f(x)(q) <| qs
				}
		}
	}
}

/// Takes a binary operator and a list and scans the function across each element of the list 
/// accumulating the results of successive function calls applied to the reduced values from the 
/// right to the left.
public func scanr1<A>(f : (A, A) -> A) -> [A] -> [A] {
	return { l in
		switch destruct(l) {
			case .Empty:
				return []
			case .Cons(let x, let xs) where xs.count == 0:
				return [x]
			case .Cons(let x, let xs):
				let qs = scanr1(f)(xs)
				switch destruct(qs) {
					case .Empty:
						fatalError("Cannot scanr1 across an empty list.")
					case .Cons(let q, _):
						return f(x, q) <| qs
				}
		}
	}
}

