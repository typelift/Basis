//
//  Maybe.swift
//  Basis
//
//  Created by Robert Widmann on 9/11/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public enum MaybeD<A> {
	case Nothing
	case Just(A)
}

/// The Maybe type wraps an optional value.  That is, it represents a value that either exists
/// (Just) or does not (Nothing).  They can be used to model computations that may or may not
/// return a value -where Nothing serves as the error case.  If a more specific error handling type
/// is needed, consider using Either or Result which both have explicit error cases.
///
/// This class is a temporary shim around Optionals until a future swift re-allows extending generic
/// classes and structures outside the current module.
public struct Maybe<A> {
	let val : A?

	init(_ val : A?) {
		self.val = val
	}

	public func destruct() -> MaybeD<A> {
		return (val == nil) ? .Nothing : .Just(val!)
	}

	public static func nothing() -> Maybe<A> {
		return Maybe(nil)
	}

	public static func just(x : A) -> Maybe<A> {
		return Maybe(x)
	}
}

/// Takes a default value, a function, and a maybe.  If the maybe is Nothing, the default value
/// is returned.  If the maybe is Just, the function is applied to the value inside.
public func maybe<A, B>(def : B) -> (A -> B) -> Maybe<A> -> B {
	return { f in { m in
		switch m.destruct() {
			case .Nothing:
				return def
			case .Just(let x):
				return f(x)
		}
	} }
}

/// Returns whether a given maybe contains a value.
public func isJust<A>(o : Maybe<A>) -> Bool {
	switch o.destruct() {
		case .Nothing:
			return false
		default:
			return true
	}
}

/// Returns whether a given maybe is empty.
public func isNothing<A>(o : Maybe<A>) -> Bool {
	switch o.destruct() {
		case .Nothing:
			return true
		default:
			return false
	}
}

/// Returns the value from a Maybe.
///
/// If the given maybe is Nothing, this function throws an exception.
public func fromJust<A>(m : Maybe<A>) -> A {
	switch m.destruct() {
		case .Nothing:
			return error("Cannot extract value from Nothing")
		case .Just(let x):
			return x
	}
}

/// Takes a default value and a maybe.  If the maybe is empty, the default value is returned.
/// If the maybe contains a value, that value is returned.
///
/// This function is a safer form of !-unwrapping for optionals.
public func fromMaybe<A>(def : A)(m : Maybe<A>) -> A {
	switch m.destruct() {
		case .Nothing:
			return def
		case .Just(let x):
			return x
	}
}

/// Given a maybe, returns an empty list if it is Nothing, or a singleton list containing the
/// contents of a Just.
public func maybeToList<A>(o : Maybe<A>) -> [A] {
	switch o.destruct() {
		case .Nothing:
			return []
		case .Just(let x):
			return [x]
	}
}

/// Given a list, returns Nothing if the list is empty, or Just containing the head of the list.
public func listToMaybe<A>(l : [A]) -> Maybe<A> {
	switch destruct(l) {
		case .Empty:
			return Maybe.nothing()
		case .Destructure(let x, _):
			return Maybe.just(x)
	}
}

/// Takes a list of maybes and returns a list of all the values of the Just's in the list.
public func catMaybes<A>(l : [Maybe<A>]) -> [A] {
	return concatMap(maybeToList)(l)
}

/// Maps a function over a list.  If the result of the function is Nothing, the value is not included
/// in the resulting list.
public func mapMaybes<A, B>(f : A -> Maybe<B>)(l : [A]) -> [B] {
	switch destruct(l) {
		case .Empty:
			return []
		case let .Destructure(x, xs):
			let rs = mapMaybes(f)(l: xs)
			switch f(x).destruct() {
				case .Nothing:
					return rs
				case .Just(let r):
					return r <| rs
			}
	}
}

// MARK: Equatable
public func ==<V : Equatable>(lhs: Maybe<V>, rhs: Maybe<V>) -> Bool {
	switch (lhs.destruct(), rhs.destruct()) {
		case (.Nothing, .Nothing):
			return true
		case let (.Just(l), .Just(r)) where l == r:
			return true
		default:
			return false
	}
}

// Fallback equality: All nothings are isomorphic.
public func ==<T, V>(lhs: Maybe<T>, rhs: Maybe<V>) -> Bool {
	switch (lhs.destruct(), rhs.destruct()) {
	case (.Nothing, .Nothing):
		return true
	default:
		return false
	}
}

public func !=<V: Equatable>(lhs: Maybe<V>, rhs: Maybe<V>) -> Bool {
	return !(lhs == rhs)
}

public func !=<T, V>(lhs: Maybe<T>, rhs: Maybe<V>) -> Bool {
	return !(lhs == rhs)
}

// MARK: Functor

extension Maybe : Functor {
	typealias B = Any
	
	typealias FA = Maybe<A>
	typealias FB = Maybe<B>
	

	public static func fmap<B>(f : A -> B) -> Maybe<A> -> Maybe<B> {
		return { m in
			switch m.destruct() {
				case .Nothing:
					return Maybe<B>.nothing()
				case .Just(let x):
					return Maybe<B>.just(f(x))
			}
		}
	}
}

public func <%><A, B>(f : A -> B, o : Maybe<A>) -> Maybe<B> {
	return Maybe.fmap(f)(o)
}

public func <%<A, B>(x : A, o : Maybe<B>) -> Maybe<A> {
	return (curry(<%>) • const)(x)(o)
}

extension Maybe : Applicative {
	typealias FAB = Maybe<A -> B>
	
	public static func pure(x : A) -> Maybe<A> {
		return Maybe.just(x)
	}
}

public func <*><A, B>(f : Maybe<A -> B> , o : Maybe<A>) -> Maybe<B> {
	switch f.destruct() {
		case .Nothing:
			return Maybe.nothing()
		case .Just(let f):
			return f <%> o
	}
}


public func *><A, B>(a : Maybe<A>, b : Maybe<B>) -> Maybe<B> {
	return const(id) <%> a <*> b
}

public func <*<A, B>(a : Maybe<A>, b : Maybe<B>) -> Maybe<A> {
	return const <%> a <*> b
}

extension Maybe : Alternative {
	typealias FLA = Maybe<[A]>
	
	public func empty() -> Maybe<A> {
		return Maybe.nothing()
	}
	
	public func some(v : Maybe<A>) -> Maybe<[A]> {
		return curry((<|)) <%> v <*> many(v)
	}
	
	public func many(v : Maybe<A>) -> Maybe<[A]> {
		return some(v) <|> Maybe<[A]>.pure([])
	}
}

public func <|><A>(l : Maybe<A>, r : Maybe<A>) -> Maybe<A> {
	switch l.destruct() {
		case .Nothing:
			return r
		case .Just(_):
			return l
	}
}

extension Maybe : Monad {
	public func bind<B>(f : A -> Maybe<B>) -> Maybe<B> {
		switch self.destruct() {
			case .Nothing:
				return Maybe<B>.nothing()
			case .Just(let x):
				return f(x)
		}
	}
}

public func >>-<A, B>(x : Maybe<A>, f : A -> Maybe<B>) -> Maybe<B> {
	return x.bind(f)
}

extension Maybe : MonadPlus {
	public static func mzero() -> Maybe<A> {
		return Maybe.nothing()
	}
	
	public static func mplus(l : Maybe<A>) -> Maybe<A> -> Maybe<A> {
		return { r in
			switch l.destruct() {
				case .Nothing:
					return r
				default:
					return l
			}
		}
	}
}
