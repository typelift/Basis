//
//  Compare.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func sortBy<A>(cmp : A -> A -> Bool)(lst : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(lst: lst)
}

public func sortBy<A>(cmp : (A, A) -> Bool)(lst : [A]) -> [A] {
	return foldr(insertBy(cmp))(z: [])(lst: lst)
}

public func insertBy<A>(cmp: A -> A -> Bool)(x : A)(lst : [A]) -> [A] {
	switch lst.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x)(y) {
				return y +> insertBy(cmp)(x: x)(lst: ys)
			}
			return x +> lst
	}
}

public func insertBy<A>(cmp: (A, A) -> Bool)(x : A)(lst : [A]) -> [A]  {
	switch lst.destruct() {
		case .Empty:
			return [x]
		case .Destructure(let y, let ys):
			if cmp(x, y) {
				return y +> insertBy(cmp)(x: x)(lst: ys)
			}
			return x +> lst
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
				})(xs0: $0)
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
			})(xs0: $0)
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
			})(xs0: $0)
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
			})(xs0: $0)
		}
	}
}

