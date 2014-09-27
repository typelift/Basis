//
//  List.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Returns the first element of a non-empty list.
///
/// If the provided list is empty, this function throws an exception.
public func head<A>(l : [A]) -> A {
	switch l.destruct() {
		case .Empty:
			assert(false, "Cannot take the head of an empty list.")
		case .Destructure(let x, _):
			return x
	}
}

/// Returns an array of all elements but the first in a non-empty list.
///
/// If the provided list if empty, this function throws an exception.
public func tail<A>(l : [A]) -> [A] {
	switch l.destruct() {
		case .Empty:
			assert(false, "Cannot take the tail of an empty list.")
		case .Destructure(_, let xs):
			return xs
	}
}

infix operator ++ { associativity left }

func ++<T>(var lhs : [T], rhs : [T]) -> [T] {
	lhs += rhs
	return lhs
}

infix operator +> { associativity right }

func +><T>(lhs : T, rhs : [T]) -> [T] {
	var arr = rhs
	arr.insert(lhs, atIndex: 0)
	return arr
}


public enum ArrayD<A> {
	case Empty
	case Destructure(A, [A])
}

extension Array {
	public func destruct() -> ArrayD<T> {
		if self.count == 0 {
			return .Empty
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
	
	public static func fmap<B>(f: A -> B) -> Array<A> -> Array<B> {
		return { $0.map(f) }
	}
}

public func <%<A, B>(x : A, l : Array<B>) -> Array<A> {
	return Array.fmap(const(x))(l)
}

extension Array : Applicative {
	typealias FAB = Array<A -> B>

	public static func pure(x : A) -> Array<A> {
		return [x]
	}
}

public func <%><A, B>(f: A -> B, ar : Array<A>) -> Array<B> {
	return Array.fmap(f)(ar)
}

public func <*><A, B>(a : Array<A -> B> , l : Array<A>) -> Array<B> {
	return concat(a.map({ l.map($0) }))
}

public func *><A, B>(a : Array<A>, b : Array<B>) -> Array<B> {
	return const(id) <%> a <*> b
}

public func <*<A, B>(a : Array<A>, b : Array<B>) -> Array<A> {
	return const <%> a <*> b
}

extension Array : Alternative {
	typealias FLA = Array<[A]>
	
	public func empty() -> Array<A> {
		return []
	}
	
	public func some(v : Array<A>) -> Array<[A]> {
		return curry((+>)) <%> v <*> many(v)
	}
	
	public func many(v : Array<A>) -> Array<[A]> {
		return some(v) <|> Array<[A]>.pure([])
	}
}

public func <|><A>(l : Array<A>, r : Array<A>) -> Array<A> {
	return l ++ r
}

extension Array : Monad {	
	public func bind<B>(f : A -> Array<B>) -> Array<B> {
		return concatMap(f)(l: self)
	}
}

public func >>-<A, B>(xs : [A], f : A -> [B]) -> [B] {
	return concatMap(f)(l: xs)
}

public func >><A, B>(x : [A], y : [B]) -> [B] {
	return x >>- { (_) in
		return y
	}
}

extension Array : MonadPlus {
	public static func mzero() -> Array<T> {
		return []
	}
	
	public static func mplus(l : Array<T>) -> Array<T> -> Array<T> {
		return { l ++ $0 }
	}
}

extension Array : MonadZip {
	typealias C = Any
	typealias FC = Array<C>
	
	typealias FTAB = Array<(A, B)>
	
	public func mzip<B>(ma : Array<A>) -> Array<B> -> Array<(A, B)> {
		return zip(ma)
	}
	
	public func mzipWith<B, C>(f : A -> B -> C) -> Array<A> -> Array<B> -> Array<C> {
		return zipWith(f)
	}
	
	public func munzip<B>(ftab : Array<(A, B)>) -> (Array<A>, Array<B>) {
		return unzip(ftab)
	}
}


internal enum DDestructure<A, B> {
	case Empty
	case Destructure((A, B), [(A, B)])
}

internal func destructure<A, B>(x : [A:B]) -> DDestructure<A, B> {
	if x.count == 0 {
		return .Empty
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
