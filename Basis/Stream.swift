//
//  Stream.swift
//  Basis
//
//  Created by Robert Widmann on 12/22/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

/// A lazy infinite sequence of values.
public struct Stream<T> {
	let st : @autoclosure() -> (head : T, tail : Stream<T>)
	
	public subscript(n : UInt) -> T {
		return index(self)(n)
	}
}

/// Looks up the nth element of a Stream.
public func index<T>(s : Stream<T>) -> UInt -> T {
	return { n in
		if n == 0 {
			return s.st().head
		}
		return index(s.st().tail)(n - 1)
	}
}

/// Returns the first element of a Stream.
public func head<T>(s : Stream<T>) -> T {
	return s.st().head
}

/// Returns the remaining elements of a Stream.
public func tail<T>(s : Stream<T>) -> Stream<T> {
	return s.st().tail
}

/// Returns a Stream of all initial segments of a Stream.
public func inits<T>(s : Stream<T>) -> Stream<[T]> {
	return Stream(st: ([], map({ s.st().head <| $0 })(inits(s.st().tail))))
}

/// Returns a Stream of all final segments of a Stream.
public func tails<T>(s : Stream<T>) -> Stream<Stream<T>> {
	return Stream(st: (s, tails(s.st().tail)))
}

/// Repeats a value into a constant stream of that same value.
public func repeat<T>(x : T) -> Stream<T> {
	return Stream(st: (x, repeat(x)))
}

/// Returns a Stream of an infinite number of iteratations of applications of a function to a value.
public func iterate<T>(f : T -> T) -> T -> Stream<T> {
	return { x in Stream(st: (x, iterate(f)(f(x)))) }
}

/// Cycles a non-empty list into an infinite Stream of repeating values.
///
/// This function is partial with respect to the empty list.
public func cycle<T>(xs : [T]) -> Stream<T> {
	switch destruct(xs) {
		case .Empty:
			return error("Cannot cycle an empty list.")
		case .Cons(let x, let xs):
			return Stream(st: (x, cycle(xs + [x])))
	}
}

/// Maps a function over a Stream and returns a new Stream of those values.
public func map<A, B>(f : A -> B) -> Stream<A> -> Stream<B> {
	return { s in Stream(st: (f(s.st().head), map(f)(s.st().tail))) }
}

/// Uses function to construct a Stream.
///
/// Unlike unfold for lists, unfolds to construct a Stream have no base case.
public func unfold<A, B>(f : A -> (B, A)) -> A -> Stream<B> {
	return { z in  
		let (x, d) = f(z)
		return Stream(st: (x, unfold(f)(d)))
	}
}

/// Returns a Stream of alternating elements from each Stream.
public func interleave<T>(s1 : Stream<T>) -> Stream<T> -> Stream<T> {
	return { s2 in Stream(st: (s1.st().head, interleave(s2)(s1))) }
}

/// Creates a Stream alternating an element in between the values of another Stream.
public func intersperse<T>(x : T) -> Stream<T> -> Stream<T> {
	return { s in Stream(st: (s.st().head, Stream(st: (x, intersperse(x)(s.st().tail))))) }
}

/// Returns a Stream of successive reduced values.
public func scanl<A, B>(f : A -> B -> A) -> A -> Stream<B> -> Stream<A> {
	return { z in { s in Stream(st: (z, scanl(f)(f(z)(s.st().head))(s.st().tail))) } }
}

/// Returns a Stream of successive reduced values.
public func scanl1<A>(f : A -> A -> A) -> Stream<A> -> Stream<A> {
	return { s in scanl(f)(s.st().head)(s.st().tail) }
}

/// Transposes the "Rows and Columns" of an infinite Stream.
public func transpose<T>(ss : Stream<Stream<T>>) -> Stream<Stream<T>> {
	let xs = ss.st().head
	let yss = ss.st().tail
	return Stream(st: (Stream(st: (xs.st().head, map(head)(yss))), transpose(Stream(st: (xs.st().tail, map(tail)(yss)))))) 
}

/// Returns the first n elements of a Stream.
public func take<T>(n : UInt) -> Stream<T> -> [T] {
	return { s in  
		if n == 0 {
			return []
		}
		return s.st().head <| take(n - 1)(s.st().tail)
	}
}

/// Returns a Stream with the first n elements removed.
public func drop<T>(n : UInt) -> Stream<T> -> Stream<T> {
	return { s in  
		if n == 0 {
			return s
		}
		return drop(n - 1)(tail(s.st().tail))
	}
}

/// Returns a pair of the first n elements and the remaining eleemnts in a Stream.
public func splitAt<T>(n : UInt) -> Stream<T> -> ([T], Stream<T>) {
	return { xs in 
		if n == 0 {
			return ([], xs)
		}
		let (p, r) = splitAt(n - 1)(tail(xs))
		return (head(xs) <| p, r)
	}
}

/// Returns the longest prefix of values in a Stream for which a predicate holds.
public func takeWhile<T>(p : T -> Bool) -> Stream<T> -> [T] {
	return { s in 
		if p(s.st().head) {
			return s.st().head <| takeWhile(p)(s.st().tail)
		}
		return []
	}
}

/// Returns the longest suffix remaining after a predicate holds.
public func dropWhile<T>(p : T -> Bool) -> Stream<T> -> Stream<T> {
	return { s in 
		if p(s.st().head) {
			return dropWhile(p)(s.st().tail)
		}
		return s
	}
}

/// Removes elements from the Stream that do not satisfy a given predicate.
///
/// If there are no elements that satisfy this predicate this function will diverge.
public func filter<T>(p : T -> Bool) -> Stream<T> -> Stream<T> {
	return { s in 
		if p(s.st().head) {
			return Stream(st: (s.st().head, filter(p)(s.st().tail)))
		}
		return filter(p)(s.st().tail)
	}
}

/// Zips two Streams into a Stream of pairs.
public func zip<A, B>(s1 : Stream<A>) -> Stream<B> -> Stream<(A, B)> {
	return { s2 in Stream(st: ((s1.st().head, s2.st().head), zip(s1.st().tail)(s2.st().tail))) }
}

/// Zips two Streams into a third Stream using a combining function.
public func zipWith<A, B, C>(f : A -> B -> C) -> Stream<A> -> Stream<B> -> Stream<C> {
	return { s1 in { s2 in Stream(st: (f(s1.st().head)(s2.st().head), zipWith(f)(s1.st().tail)(s2.st().tail))) } }
}

/// Unzips a Stream of pairs into a pair of Streams.
public func unzip<A, B>(sp : Stream<(A, B)>) -> (Stream<A>, Stream<B>) {
	return (map(fst)(sp), map(snd)(sp))
}
