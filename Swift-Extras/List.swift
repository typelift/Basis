//
//  List.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

infix operator ++ { associativity left }

func ++<T>(var lhs : [T], rhs : [T]) -> [T] {
	lhs += rhs
	return lhs
}

infix operator +> { associativity left }

func +><T>(lhs : T, rhs : [T]) -> [T] {
	var arr = rhs
	arr.insert(lhs, atIndex: 0)
	return arr
}


public enum ArrayD<A> {
	case Empty()
	case Destructure(A, [A])
}

extension Array {
	public func destruct() -> ArrayD<T> {
		if self.count == 0 {
			return .Empty()
		} else if self.count == 1 {
			return .Destructure(self[0], [])
		}
		let hd = self[0]
		let tl = Array<A>(self[1..<self.count])
		return .Destructure(hd, tl)
	}
}

extension Array : Functor {
	typealias A = T
	typealias B = Any
	typealias FB = Array<B>
	
	public func fmap<B>(f: A -> B) -> Array<A> -> Array<B> {
		return { $0.map(f) }
	}
}

public func <^<A, B>(x : A, l : Array<B>) -> Array<A> {
	return l.fmap(const(x))(l)
}

//extension Array : Applicative {
//	typealias FAB = Array<A -> B>
//
//	public func pure(x : A) -> Array<A> {
//		return [x]
//	}
//}

//public func <*><A, B>(a : Array<A -> B> , l : Array<A>) -> Array<B> {
//	return
//}

//public func *><A, B>(a : Array<A>, b : Array<B>) -> Array<B> {
//	return const(id) <$> a <*> b
//}
//
//public func <*<A, B>(Array<A>, Array<B>) -> Array<A> {
//	return const <$> a <*> b
//}


internal enum DDestructure<A, B> {
	case Empty()
	case Destructure((A, B), [(A, B)])
}

internal func destructure<A, B>(x : [A:B]) -> DDestructure<A, B> {
	if x.count == 0 {
		return .Empty()
	} else if x.count == 1 {
		var g = x.generate()
		return .Destructure(g.next()!, [])
	}
	var g = x.generate()
	let hd = g.next()!
	var arr : [(A, B)] = []
	while let v = g.next() {
		arr = v +> arr
	}
	return .Destructure(hd, arr)
}
