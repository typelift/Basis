//
//  Tuple.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Extract the first component of a pair.
public func fst<A, B>(t : (A, B)) -> A {
	return t.0
}

/// Extract the second component of a pair
public func snd<A, B>(t : (A, B)) -> B {
	return t.1
}

/// Converts an uncurried function to a curried function.
///
/// A curried function is a function that always returns another function or a value when applied
/// as opposed to an uncurried function which may take tuples.
public func curry<A, B, C>(f : (A, B) -> C) ->  A -> B -> C {
	return { a in
		return { b in
			return f((a, b))
		}
	}
}

/// Converts a curried function to an uncurried function.
///
/// An uncurried function may take tuples as opposed to a curried function which must take a single
/// value and return a single value or function.
public func uncurry<A, B, C>(f : A -> B -> C) -> (A, B) -> C {
	return { t in
		return f(fst(t))(snd(t))
	}
}

/// Swap the components of a pair.
public func swap<A, B>(t : (A, B)) -> (B, A) {
	return snd(t) ∏ fst(t)
}

/// Pair Formation | Forms a pair from two arguments.  (⌥ + ⇧ + P)
///
/// (,), the pair formation operator, is a reserved symbol in Swift with a meaning beyond just 
/// tuple formation.  This means it is also not a proper function.
public func ∏<A, B>(l : A, r : B) -> (A, B) {
	return (l, r)
}

/// Pack a tuple.
public func pack2<A, B>(a : A)(b : B) -> (A, B) {
	return (a, b)
}

/// Pack a triple.
public func pack3<A, B, C>(a : A)(b : B)(c : C) -> (A, B, C) {
	return (a, b, c)
}

/// pack a quadruple
public func pack4<A, B, C, D>(a : A)(b : B)(c : C)(d : D) -> (A, B, C, D) {
	return (a, b, c, d)
}

/// pack a quintuple
public func pack5<A, B, C, D, E>(a : A)(b : B)(c : C)(d : D)(e : E) -> (A, B, C, D, E) {
	return (a, b, c, d, e)
}

/// pack a sextuple
public func pack6<A, B, C, D, E, F>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F) -> (A, B, C, D, E, F) {
	return (a, b, c, d, e, f)
}

/// pack a septuple
public func pack7<A, B, C, D, E, F, G>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G) -> (A, B, C, D, E, F, G) {
	return (a, b, c, d, e, f, g)
}

/// pack an octuple
public func pack8<A, B, C, D, E, F, G, H>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H) -> (A, B, C, D, E, F, G, H) {
	return (a, b, c, d, e, f, g, h)
}

/// pack a nontuple
public func pack9<A, B, C, D, E, F, G, H, I>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I) -> (A, B, C, D, E, F, G, H, I) {
	return (a, b, c, d, e, f, g, h, i)
}

/// pack a dectuple
public func pack10<A, B, C, D, E, F, G, H, I, J>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J) -> (A, B, C, D, E, F, G, H, I, J) {
	return (a, b, c, d, e, f, g, h, i, j)
}

/// pack an undectuple
public func pack11<A, B, C, D, E, F, G, H, I, J, K>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K) -> (A, B, C, D, E, F, G, H, I, J, K) {
	return (a, b, c, d, e, f, g, h, i, j, k)
}

/// pack a duodectuple
public func pack12<A, B, C, D, E, F, G, H, I, J, K, L>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K, l : L) -> (A, B, C, D, E, F, G, H, I, J, K, L) {
	return (a, b, c, d, e, f, g, h, i, j, k, l)
}

/// pack a tredectuple
public func pack13<A, B, C, D, E, F, G, H, I, J, K, L, M>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K, l : L)(m : M) -> (A, B, C, D, E, F, G, H, I, J, K, L, M) {
	return (a, b, c, d, e, f, g, h, i, j, k, l, m)
}

/// pack a quatuordectuple
public func pack14<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K, l : L)(m : M)(n : N) -> (A, B, C, D, E, F, G, H, I, J, K, L, M, N) {
	return (a, b, c, d, e, f, g, h, i, j, k, l, m, n)
}

/// pack a quindectuple
public func pack15<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K, l : L)(m : M)(n : N)(o : O) -> (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) {
	return (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
}

/// pack a sexdectuple
public func pack16<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(a : A)(b : B)(c : C)(d : D)(e : E)(f : F)(g : G)(h : H)(i : I)(j : J)(k : K, l : L)(m : M)(n : N)(o : O)(p : P) -> (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) {
	return (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
}
