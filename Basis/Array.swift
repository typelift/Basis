//
//  Array.swift
//  Basis
//
//  Created by Robert Widmann on 1/11/15.
//  Copyright (c) 2015 Robert Widmann. All rights reserved.
//

public enum ArrayMatcher<A> {
	case Nil
	case Cons(A, [A])
}

/// Returns the first element of a non-empty array.
///
/// If the provided array is empty, this function throws an exception.
public func head<A>(l : [A]) -> A {
	switch match(l) {
		case .Nil:
			fatalError("Cannot take the head of an empty list.")
		case .Cons(let x, _):
			return x
	}
}

/// Returns an array of all elements but the first in a non-empty array.
///
/// If the provided array if empty, this function throws an exception.
public func tail<A>(l : [A]) -> [A] {
	switch match(l) {
		case .Nil:
			fatalError("Cannot take the tail of an empty list.")
		case .Cons(_, let xs):
			return xs
	}
}

public func cons<T>(x : T) -> [T] -> [T] {
	return { xs in x <| xs }
}

public func <| <T>(lhs : T, var rhs : [T]) -> [T] {
	rhs.insert(lhs, atIndex: 0)
	return rhs
}

/// Returns a list with n values of x in it.
public func replicate<A>(n : Int) -> A -> [A] {
	return { x in Array(count: n, repeatedValue: x) }
}

/// Destructures a list into its constituent parts.
///
/// If the given list is empty, this function returns .Empty.  If the list is non-empty, this
/// function returns .Cons(hd, tl)
public func match<T>(l : [T]) -> ArrayMatcher<T> {
	if l.count == 0 {
		return .Nil
	} else if l.count == 1 {
		return .Cons(l[0], [])
	}
	let hd = l[0]
	let tl = Array<T>(l[1..<l.count])
	return .Cons(hd, tl)
}

/// Takes two lists and returns true if the first list is a prefix of the second list.
public func isPrefixOf<A : Equatable>(l : [A]) -> [A] -> Bool {
	return { r in
		switch (match(l), match(r)) {
			case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
				return isPrefixOf(xs)(ys)
			case (.Nil, _):
				return true
			default:
				return false
		}
	}
}

/// Takes two lists and returns true if the first list is a suffix of the second list.
public func isSuffixOf<A : Equatable>(l : [A]) -> [A] -> Bool {
	return { r in isPrefixOf(Array(l.reverse()))(Array(r.reverse())) }
}

/// Takes two lists and returns true if the first list is contained entirely anywhere in the second
/// list.
public func isInfixOf<A : Equatable>(l : [A]) -> [A] -> Bool {
	return { r in any(isPrefixOf(l))(tails(r)) }
}

/// Takes two lists and drops items in the first from the second.  If the first list is not a prefix
/// of the second list this function returns Nothing.
public func stripPrefix<A : Equatable>(l : [A]) -> [A] -> Optional<[A]> {
	return { r in
		switch (match(l), match(r)) {
			case (.Nil, _):
				return .Some(r)
			case (.Cons(let x, let xs), .Cons(let y, let ys)) where x == y:
				return stripPrefix(xs)(ys)
			default:
				return nil
		}
	}
}

/// Takes two lists and drops items in the first from the end of the second.  If the first list is
/// not a suffix of the second list this function returns nothing.
public func stripSuffix<A : Equatable>(l : [A]) -> [A] -> Optional<[A]> {
	return { r in stripPrefix(l.reverse())(r.reverse()).map { $0.reverse() } }
}

extension Array : Functor {
	public typealias A = Element
	public typealias B = Any
	public typealias FB = Array<B>

	public static func fmap<B>(f : A -> B) -> Array<A> -> Array<B> {
		return { $0.map(f) }
	}
}

public func <%<A, B>(x : A, l : Array<B>) -> Array<A> {
	return l.map(const(x))
}

extension Array : Applicative {
	public typealias FAB = Array<A -> B>

	public static func ap<B>(fxs : Array<A -> B>) -> Array<A> -> Array<B> {
		return { fxs <*> $0 }
	}

	
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
	public typealias FLA = Array<[A]>

	public func empty() -> Array<A> {
		return []
	}

	public func some(v : Array<A>) -> Array<[A]> {
		return curry(<|) <%> v <*> many(v)
	}

	public func many(v : Array<A>) -> Array<[A]> {
		return some(v) <|> Array<[A]>.pure([])
	}
	
	public func optional(v : Array<A>) -> Array<Optional<A>> {
		return Optional.Some <%> v <|> Array<Optional<A>>.pure(.None)
	}
}

public func <|><A>(l : Array<A>, r : Array<A>) -> Array<A> {
	return l + r
}

extension Array : Monad {
	public func bind<B>(f : Element -> Array<B>) -> Array<B> {
		return self.flatMap(f)
	}
}

public func >>- <A, B>(xs : Array<A>, f : A -> Array<B>) -> Array<B> {
	return xs.flatMap(f)
}

public func >> <A, B>(l : [A], r : [B]) -> [B] {
	return l.flatMap { _ in
		return r
	}
}

extension Array : MonadPlus {
	public static func mplus(l : Array<Element>) -> Array<Element> -> Array<Element> {
		return { l + $0 }
	}
}

extension Array : MonadZip {
	public typealias C = Any
	public typealias FC = Array<C>

	public typealias FTAB = Array<(A, B)>

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
		arr = (v <| arr)
	}
	return .Destructure(hd, arr)
}
