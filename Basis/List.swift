//
//  List.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// An enum representing the possible values a list can match against.
public enum ListMatcher<A> {
	/// The empty list.
	case Nil
	/// A cons cell.
	case Cons(A, List<A>)
}

/// A lazy ordered sequence of homogenous values.
///
/// A List is typically constructed by two primitives: Nil and Cons.  Due to limitations of the
/// language, we instead provide a nullary constructor for Nil and a Cons Constructor and an actual
/// static function named `cons(: tail:)` for Cons.  Nonetheless this representation of a list is
/// isomorphic to the traditional inductive definition.  As such, the method `match()` is provided
/// that allows the list to be destructured into a more traditional `Nil | Cons(A, List<A>)` form
/// that is also compatible with switch-case blocks.
///
/// This kind of list is optimized for access to its length, which always occurs in O(1), and
/// modifications to its head, which always occur in O(1).  Access to the elements occurs in O(n).
///
/// Unlike an Array, a List can potentially represent an infinite sequence of values.  Because the
/// List holds these values in a lazy manner, certain primitives like iteration or reversing the
/// list will force evaluation of the entire list.  For infinite lists this can lead to a program
/// diverging.
public struct List<A> {
	let count : Int
	let next : () -> (head : A, tail : List<A>)

	/// Constructs a potentially infinite list.
	init(_ next : () -> (head : A, tail : List<A>), isEmpty : Bool = false) {
		self.count = isEmpty ? 0 : -1
		self.next = next
	}

	/// Constructs the empty list.
	///
	/// Attempts to access the head or tail of this list in an unsafe manner will throw an exception.
	public init() {
		self.init({ (error("Attempted to access the head of the empty list."), error("Attempted to access the tail of the empty list.")) }, isEmpty: true)
	}

	/// Construct a list with a given head and tail.
	public init(_ head : A, _ tail : List<A> = List<A>()) {
		if tail.count == -1 {
			self.count = -1
		} else {
			self.count = tail.count.successor()
		}
		self.next = { (head, tail) }
	}

	/// Destructures a list.  If the list is empty, the result is Nil.  If the list contains a value
	/// the result is Cons(head, tail).
	public func match() -> ListMatcher<A> {
		if self.count == 0 {
			return .Nil
		}
		let (hd, tl) = self.next()
		return .Cons(hd, tl)
	}

	/// Indexes into an array.
	///
	/// Indexing into the empty list will throw an exception.
	public subscript(n : UInt) -> A {
		switch self.match() {
			case .Nil:
				return error("Cannot extract an element from an empty list.")
			case let .Cons(x, _) where n == 0:
				return x
			case let .Cons(_, xs):
				return xs[n - 1]
		}
	}

	/// Returns whether or not the receiver is the empty list.
	public func isEmpty() -> Bool {
		return self.count == 0
	}

	/// Returns whether or not the receiver has a countable number of elements.
	///
	/// It may be dangerous to attempt to iterate over an infinite list of values because the loop
	/// will never terminate.
	public func isFinite() -> Bool {
		return self.count != -1
	}

	/// Returns the length of the list.
	///
	/// For infinite lists this function will throw an exception.
	public func length() -> UInt {
		if self.count == -1 {
			return error("Cannot take the length of an infinite list.")
		}
		return UInt(self.count)
	}

	/// Returns the elements of the receiver in reverse order.
	///
	/// For infinite lists this function will diverge.
	public func reverse() -> List<A> {
		return foldl(flip(cons))(List())(self)
	}

	/// Yields a new list by applying a function to each element of the receiver.
	public func map<B>(f : A -> B) -> List<B> {
		switch self.match() {
			case .Nil:
				return List<B>()
			case let .Cons(hd, tl):
				return List<B>(f(hd), tl.map(f))
		}
	}

	/// Appends two lists together.
	///
	/// If the receiver is infinite, the result of this function will be the receiver itself.
	public func append(rhs : List<A>) -> List<A> {
		switch self.match() {
		case .Nil:
			return rhs
		case let .Cons(x, xs):
			return x <| xs.append(rhs)
		}
	}

	/// Returns a list of elements satisfying a predicate.
	public func filter(p : A -> Bool) -> List<A> {
		switch self.match() {
			case .Nil:
				return List()
			case let .Cons(x, xs):
				return p(x) ? List(x, xs.filter(p)) : xs.filter(p)
		}
	}
}

/// Returns the first element of a non-empty list.
///
/// If the provided list is empty, this function throws an exception.
public func head<A>(l : List<A>) -> A {
	switch l.match() {
		case .Nil:
			fatalError("Cannot take the head of an empty list.")
		case .Cons(let x, _):
			return x
	}
}

/// Returns an array of all elements but the first in a non-empty list.
///
/// If the provided list if empty, this function throws an exception.
public func tail<A>(l : List<A>) -> List<A> {
	switch l.match() {
		case .Nil:
			fatalError("Cannot take the tail of an empty list.")
		case .Cons(_, let xs):
			return xs
	}
}

public func cons<T>(x : T) -> List<T> -> List<T> {
	return { xs in x <| xs }
}

public func <| <T>(head : T, tail : List<T>) -> List<T> {
	return List(head, tail)
}

public func snoc<T>(xs : List<T>) -> T -> List<T> {
	return { x in xs |> x }
}

public func |> <T>(xs : List<T>, x : T) -> List<T> {
	return xs + List(x)
}

/// Appends two lists together.
public func + <A>(lhs : List<A>, rhs : List<A>) -> List<A> {
	return lhs.append(rhs)
}

/// Takes two lists and returns true if the first list is a prefix of the second list.
public func isPrefixOf<A : Equatable>(l : List<A>) -> List<A> -> Bool {
	return { r in
		switch (l.match(), r.match()) {
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
public func isSuffixOf<A : Equatable>(l : List<A>) -> List<A> -> Bool {
	return { r in isPrefixOf(l.reverse())(r.reverse()) }
}

/// Takes two lists and returns true if the first list is contained entirely anywhere in the second
/// list.
public func isInfixOf<A : Equatable>(l : List<A>) -> List<A> -> Bool {
	return { r in any(isPrefixOf(l))(tails(r)) }
}

/// Takes two lists and drops items in the first from the second.  If the first list is not a prefix
/// of the second list this function returns Nothing.
public func stripPrefix<A : Equatable>(l : List<A>) -> List<A> -> Optional<List<A>> {
	return { r in
		switch (l.match(), r.match()) {
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
public func stripSuffix<A : Equatable>(l : List<A>) -> List<A> -> Optional<List<A>> {
	return { r in stripPrefix(l.reverse())(r.reverse()).map(dismember(List.reverse)) }
}


/// MARK: Equatable

public func == <A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return true
		case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
			return lHead == rHead && lTail == rTail
		default:
			return false
	}
}

/// MARK: Control.*

extension List : Functor {
	public typealias B = Any
	public typealias FB = List<B>

	public static func fmap<B>(f: A -> B) -> List<A> -> List<B> {
		return { $0.map(f) }
	}
}

public func <% <A, B>(x : A, l : List<B>) -> List<A> {
	return List.fmap(const(x))(l)
}

extension List : Pointed {
	public static func pure(x : A) -> List<A> {
		return List(x)
	}
}

extension List : Applicative {
	public typealias FAB = List<A -> B>

	public static func ap<B>(a : List<A -> B>) -> List<A> -> List<B> {
		return { l in concat(a.map({ l.map($0) })) }
	}
}

public func <%> <A, B>(f : A -> B, ar : List<A>) -> List<B> {
	return List.fmap(f)(ar)
}

public func <*> <A, B>(a : List<A -> B> , l : List<A>) -> List<B> {
	return List.ap(a)(l)
}

public func *> <A, B>(a : List<A>, b : List<B>) -> List<B> {
	return const(id) <%> a <*> b
}

public func <* <A, B>(a : List<A>, b : List<B>) -> List<A> {
	return const <%> a <*> b
}

extension List : Alternative {
	public typealias FLA = List<[A]>
	public typealias FMA = List<Optional<A>>

	public func empty() -> List<A> {
		return List()
	}

	public func some(v : List<A>) -> List<[A]> {
		return curry(<|) <%> v <*> many(v)
	}

	public func many(v : List<A>) -> List<[A]> {
		return some(v) <|> List<[A]>.pure([])
	}
	
	public func optional(v : List<A>) -> List<Optional<A>> {
		return Optional.Some <%> v <|> List<Optional<A>>.pure(.None)
	}
}

public func <|> <A>(l : List<A>, r : List<A>) -> List<A> {
	return l + r
}

extension List : Monad {
	public func bind<B>(f : A -> List<B>) -> List<B> {
		return concatMap(f)(self)
	}
}

public func >>- <A, B>(l : List<A>, f : A -> List<B>) -> List<B> {
	return l.bind(f)
}

public func >> <A, B>(x : List<A>, y : List<B>) -> List<B> {
	return x.bind({ (_) in
		return y
	})
}

extension List : MonadPlus {
	public static func mplus(l : List<A>) -> List<A> -> List<A> {
		return { l + $0 }
	}
}

extension List : MonadZip {
	public typealias C = Any
	public typealias FC = List<C>

	public typealias FTAB = List<(A, B)>

	public func mzip<B>(ma : List<A>) -> List<B> -> List<(A, B)> {
		return zip(ma)
	}

	public func mzipWith<B, C>(f : A -> B -> C) -> List<A> -> List<B> -> List<C> {
		return zipWith(f)
	}

	public func munzip<B>(ftab : List<(A, B)>) -> (List<A>, List<B>) {
		return unzip(ftab)
	}
}

