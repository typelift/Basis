//
//  Sublists.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func take<A>(n : Int)(l : [A]) -> [A] {
	if n <= 0 {
		return []
	}
	
	switch l.destruct() {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return x +> take(n - 1)(l: xs)
	}
}

public func drop<A>(n : Int)(l : [A]) -> [A] {
	if n <= 0 {
		switch l.destruct() {
			case .Empty():
				return []
			case .Destructure(let x, let xs):
				return xs
		}
	}
	
	switch l.destruct() {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			return drop(n - 1)(l: xs)
	}
}

public func splitAt<A>(n : Int)(l : [A]) -> ([A], [A]) {
	return (take(n)(l: l), drop(n)(l: l))
}

public func takeWhile<A>(p : A -> Bool)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			if p(x) {
				return x +> takeWhile(p)(l : xs)
			}
			return []
	}
}

public func dropWhile<A>(p : A -> Bool)(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty():
			return []
		case .Destructure(let x, let xs):
			if p(x) {
				return dropWhile(p)(l : xs)
			}
			return l
	}
}

public func span<A>(p : A -> Bool)(l : [A]) -> ([A], [A]) {
	switch l.destruct() {
		case .Empty():
			return ([], [])
		case .Destructure(let x, let xs):
			if p(x) {
				let (ys, zs) = span(p)(l : xs)
				return (x +> ys, zs)
			}
			return ([], l)
	}
}

public func extreme<A>(p : A -> Bool)(l : [A]) -> ([A], [A]) {
	return span({ (not • p)($0) })(l: l)
}
