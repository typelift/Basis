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
	init(_ next : @autoclosure () -> (head : A, tail : List<A>), isEmpty : Bool = false) {
		self.count = isEmpty ? 0 : -1
		self.next = next
	}

	/// Constructs the empty list.
	///
	/// Attempts to access the head or tail of this list in an unsafe manner will throw an exception.
	public init() {
		self.init((error("Attempted to access the head of the empty list."), error("Attempted to access the tail of the empty list.")), isEmpty: true)
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

	/// Appends an element onto the front of a list.
	public static func cons(head : A, tail : List<A>) -> List<A> {
		return List(head, tail)
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
			case let .Cons(x, xs) where n == 0:
				return x
			case let .Cons(x, xs):
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
			return List.cons(x, tail: xs.append(rhs))
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
		assert(false, "Cannot take the head of an empty list.")
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
		assert(false, "Cannot take the tail of an empty list.")
	case .Cons(_, let xs):
		return xs
	}
}

public func cons<T>(x : T) -> List<T> -> List<T> {
	return { xs in x <| xs }
}

public func <|<T>(lhs : T, rhs : List<T>) -> List<T> {
	return cons(lhs)(rhs)
}

/// Appends two lists together.
public func +<A>(lhs : List<A>, rhs : List<A>) -> List<A> {
	return lhs.append(rhs)
}

/// MARK: Equatable

public func ==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	switch (lhs.match(), rhs.match()) {
		case (.Nil, .Nil):
			return true
		case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
			return lHead == rHead && lTail == rTail
		default:
			return false
	}
}


