//
//  Compare.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func groupBy<A>(cmp : A -> A -> Bool)(l : [A]) -> [[A]] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			let (ys, zs) = span(cmp(x))(l: xs)
			return (x +> ys) +> groupBy(cmp)(l: zs)
	}
}

public func groupBy<A>(cmp : (A, A) -> Bool)(l : [A]) -> [[A]] {
	switch l.destruct() {
	case .Empty:
		return []
	case .Destructure(let x, let xs):
		let (ys, zs) = span({ cmp(x, $0) })(l: xs)
		return (x +> ys) +> groupBy(cmp)(l: zs)
	}
}

public func nubBy<A>(eq : A -> A -> Bool) -> [A] -> [A] {
	return { (let lst) in
		switch lst.destruct() {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return [x] + nubBy(eq)(xs.filter({ (let y) in
				return !(eq(x)(y))
			}))
		}
	}
}

public func sortBy<A>(cmp : A -> A -> Bool)(l : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(l: l)
}

public func sortBy<A>(cmp : (A, A) -> Bool)(l : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(l: l)
}

public func insertBy<A>(cmp: A -> A -> Bool)(x : A)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x)(y) {
				return y +> insertBy(cmp)(x: x)(l: ys)
			}
			return x +> l
	}
}

public func insertBy<A>(cmp: (A, A) -> Bool)(x : A)(l : [A]) -> [A]  {
	switch l.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x, y) {
				return y +> insertBy(cmp)(x: x)(l: ys)
			}
			return x +> l
	}
}


public func maximumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(t.0)(t.1) {
						return t.0
					}
					return t.1
				})(l: $0)
		}
	}
}

public func maximumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(t.0, t.1) {
						return t.0
					}
					return t.1
				})(l: $0)
		}
	}
}

public func minimumBy<A>(cmp : A -> A -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(t.0)(t.1) {
						return t.1
					}
					return t.0
				})(l: $0)
		}
	}
}

public func minimumBy<A>(cmp : (A, A) -> Bool) -> [A] -> A {
	return {
		switch $0.destruct() {
			case .Empty:
				assert(false, "")
			case .Destructure(_, _):
				return foldl1({ (let t) -> A in
					if cmp(t.0, t.1) {
						return t.1
					}
					return t.0
				})(l: $0)
		}
	}
}

