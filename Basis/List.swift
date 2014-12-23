//
//  List.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Returns the first element of a non-empty list.
///
/// If the provided list is empty, this function throws an exception.
public func head<A>(l : [A]) -> A {
	switch destruct(l) {
		case .Empty:
			assert(false, "Cannot take the head of an empty list.")
		case .Cons(let x, _):
			return x
	}
}

/// Returns an array of all elements but the first in a non-empty list.
///
/// If the provided list if empty, this function throws an exception.
public func tail<A>(l : [A]) -> [A] {
	switch destruct(l) {
		case .Empty:
			assert(false, "Cannot take the tail of an empty list.")
		case .Cons(_, let xs):
			return xs
	}
}

public func cons<T>(x : T) -> [T] -> [T] {
	return { xs in x <| xs }
}

public func <|<T>(lhs : T, var rhs : [T]) -> [T] {
	rhs.insert(lhs, atIndex: 0)
	return rhs
}

/// Returns a list with n values of x in it.
public func replicate<A>(n : Int) -> A -> [A] {
	return { x in Array(count: n, repeatedValue: x) }
}

public enum ArrayD<A> {
	case Empty
	case Cons(A, [A])
}

/// Destructures a list into its constituent parts.
///
/// If the given list is empty, this function returns .Empty.  If the list is non-empty, this
/// function returns .Cons(hd, tl)
public func destruct<T>(l : [T]) -> ArrayD<T> {
	if l.count == 0 {
		return .Empty
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
		switch (destruct(l), destruct(r)) {
			case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
				return isPrefixOf(xs)(ys)
			case (.Empty, _):
				return true
			default:
				return false
		}
	}
}

/// Takes two lists and returns true if the first list is a suffix of the second list.
public func isSuffixOf<A : Equatable>(l : [A]) -> [A] -> Bool {
	return { r in isPrefixOf(l.reverse())(r.reverse()) }
}

/// Takes two lists and returns true if the first list is contained entirely anywhere in the second
/// list.
public func isInfixOf<A : Equatable>(l : [A]) -> [A] -> Bool {
	return { r in any(isPrefixOf(l))(tails(r)) }
}

/// Takes two lists and drops items in the first from the second.  If the first list is not a prefix
/// of the second list this function returns Nothing.
public func stripPrefix<A : Equatable>(l : [A]) -> [A] -> Maybe<[A]> {
	return { r in
		switch (destruct(l), destruct(r)) {
			case (.Empty, _):
				return Maybe.just(r)
			case (.Cons(let x, let xs), .Cons(let y, let ys)) where x == y:
				return stripPrefix(xs)(ys)
			default:
				return Maybe.nothing()
		}
	}
}

/// Takes two lists and drops items in the first from the end of the second.  If the first list is 
/// not a suffix of the second list this function returns nothing.
public func stripSuffix<A : Equatable>(l : [A]) -> [A] -> Maybe<[A]> {
	return { r in Maybe.fmap(reverse) <| stripPrefix(l.reverse())(r.reverse()) }
}

//extension Array : Functor {
//	typealias A = T
//	typealias B = Any
//	typealias FB = Array<B>
//	
//	public static func fmap<B>(f: A -> B) -> Array<A> -> Array<B> {
//		return { $0.map(f) }
//	}
//}
//
//public func <%<A, B>(x : A, l : Array<B>) -> Array<A> {
//	return Array.fmap(const(x))(l)
//}
//
//extension Array : Applicative {
//	typealias FAB = Array<A -> B>
//
//	public static func pure(x : A) -> Array<A> {
//		return [x]
//	}
//}
//
//public func <%><A, B>(f: A -> B, ar : Array<A>) -> Array<B> {
//	return Array.fmap(f)(ar)
//}
//
//public func <*><A, B>(a : Array<A -> B> , l : Array<A>) -> Array<B> {
//	return concat(a.map({ l.map($0) }))
//}
//
//public func *><A, B>(a : Array<A>, b : Array<B>) -> Array<B> {
//	return const(id) <%> a <*> b
//}
//
//public func <*<A, B>(a : Array<A>, b : Array<B>) -> Array<A> {
//	return const <%> a <*> b
//}
//
//extension Array : Alternative {
//	typealias FLA = Array<[A]>
//	
//	public func empty() -> Array<A> {
//		return []
//	}
//	
//	public func some(v : Array<A>) -> Array<[A]> {
//		return curry((+>)) <%> v <*> many(v)
//	}
//	
//	public func many(v : Array<A>) -> Array<[A]> {
//		return some(v) <|> Array<[A]>.pure([])
//	}
//}
//
//public func <|><A>(l : Array<A>, r : Array<A>) -> Array<A> {
//	return l ++ r
//}
//
//extension Array : Monad {	
//	public func bind<B>(f : A -> Array<B>) -> Array<B> {
//		return concatMap(f)(l: self)
//	}
//}
//
//extension Array : MonadPlus {
//	public static func mzero() -> Array<T> {
//		return []
//	}
//	
//	public static func mplus(l : Array<T>) -> Array<T> -> Array<T> {
//		return { l ++ $0 }
//	}
//}
//
//extension Array : MonadZip {
//	typealias C = Any
//	typealias FC = Array<C>
//	
//	typealias FTAB = Array<(A, B)>
//	
//	public func mzip<B>(ma : Array<A>) -> Array<B> -> Array<(A, B)> {
//		return zip(ma)
//	}
//	
//	public func mzipWith<B, C>(f : A -> B -> C) -> Array<A> -> Array<B> -> Array<C> {
//		return zipWith(f)
//	}
//	
//	public func munzip<B>(ftab : Array<(A, B)>) -> (Array<A>, Array<B>) {
//		return unzip(ftab)
//	}
//}


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
