//
//  Scans.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func scanl<B, A>(f : B -> A -> B)(q : B)(ls : [A]) -> [B] {
	switch destructure(ls) {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: f(q)(x))(ls: xs)
	}
}

public func scanl<B, A>(f : (B, A) -> B)(q : B)(ls : [A]) -> [B] {
	switch destructure(ls) {
	case .Empty():
		return []
	case .Destructure(let x, let xs):
		return scanl(f)(q: f(q, x))(ls: xs)
	}
}

public func scanl1<A>(f : A -> A -> A)(l: [A]) -> [A]{
	switch destructure(l) {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: x)(ls: xs)
	}
}

public func scanl1<A>(f : (A, A) -> A)(l: [A]) -> [A]{
	switch destructure(l) {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return scanl(f)(q: x)(ls: xs)
	}
}

public func scanr<B, A>(f : A -> B -> B)(q : B)(ls : [A]) -> [B] {
	switch destructure(ls) {
		case .Empty():
			return [q]
		case .Destructure(let x, let xs):
			return f(x)(q) +> scanr(f)(q: q)(ls: xs)
	}
}

public func scanr<B, A>(f : (A, B) -> B)(q : B)(ls : [A]) -> [B] {
	switch destructure(ls) {
		case .Empty():
			return [q]
		case .Destructure(let x, let xs):
			return f(x, q) +> scanr(f)(q: q)(ls: xs)
	}
}

public func scanr1<A>(f : A -> A -> A)(l: [A]) -> [A]{
	switch destructure(l) {
		case .Empty():
			return []
		case .Destructure(let x, let xs) where xs.count == 0:
			return [x]
		case .Destructure(let x, let xs):
			let qs = scanr1(f)(l: xs)
			switch destructure(qs) {
			case .Empty():
				assert(false, "")
			case .Destructure(let q, _):
				return f(x)(q) +> qs
		}
	}
}

public func scanr1<A>(f : (A, A) -> A)(l: [A]) -> [A]{
	switch destructure(l) {
		case .Empty():
			return []
		case .Destructure(let x, let xs) where xs.count == 0:
			return [x]
		case .Destructure(let x, let xs):
			let qs = scanr1(f)(l: xs)
			switch destructure(qs) {
				case .Empty():
					assert(false, "")
				case .Destructure(let q, _):
					return f(x, q) +> qs
			}
	}
}

