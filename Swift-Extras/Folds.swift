//
//  Folds.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func foldl<A, B>(f: B -> A -> B) (z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return foldl(f)(z: f(z)(x))(lst: xs)
	}
}

public func foldl<A, B>(f: (B, A) -> B) (z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return foldl(f)(z: f(z, x))(lst: xs)
	}
}

public func foldl1<A>(f: A -> A -> A)(xs0: [A]) -> A {
	let hd = xs0[0]
	let tl = Array<A>(xs0[1..<xs0.count])
	return foldl(f)(z: hd)(lst: tl)
}

public func foldl1<A>(f: (A, A) -> A)(xs0: [A]) -> A {
	let hd = xs0[0]
	let tl = Array<A>(xs0[1..<xs0.count])
	return foldl(f)(z: hd)(lst: tl)
}

public func foldr<A, B>(k: A -> B -> B)(z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return k(x)(foldr(k)(z: z)(lst: xs))
	}
}

public func foldr<A, B>(k: (A, B) -> B)(z: B)(lst: [A]) -> B {
	switch lst.destruct() {
		case .Empty:
			return z
		case .Destructure(let x, let xs):
			return k(x, foldr(k)(z: z)(lst: xs))
	}
}

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

public func and(l : [Bool]) -> Bool {
	return foldr({$0 && $1})(z: true)(lst: l)
}

public func or(l : [Bool]) -> Bool {
	return foldr({$0 || $1})(z: true)(lst: l)
}

public func any<A>(p : A -> Bool)(l : [A]) -> Bool {
	return or(l.map(p))
}

public func all<A>(p : A -> Bool)(l : [A]) -> Bool {
	return and(l.map(p))
}

public func concat<A>(xss : [[A]]) -> [A] {
	return foldr({ $0 ++ $1 })(z: [])(lst: xss)
}

public func concatMap<A, B>(f : A -> [B])(l : [A]) -> [B] {
	return foldr({ $1 ++ f($0) })(z: [])(lst: l)
}

public func maximum<A : Comparable>(lst : [A]) -> A {
	assert(lst.count != 0, "Cannot maximum foldr1 with an empty list.")

	return foldl1(max)(xs0: lst)
}

public func minimum<A : Comparable>(lst : [A]) -> A {
	assert(lst.count != 0, "Cannot minimum foldr1 with an empty list.")

	return foldl1(min)(xs0: lst)
}


