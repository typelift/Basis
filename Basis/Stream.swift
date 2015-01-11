//
//  Stream.swift
//  Basis
//
//  Created by Robert Widmann on 12/22/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// A lazy infinite sequence of values.
public struct Stream<T> {
	let step : @autoclosure() -> (head : T, tail : Stream<T>)
	
	init(_ step : @autoclosure() -> (head : T, tail : Stream<T>)) {
		self.step = step
	}
	
	public subscript(n : UInt) -> T {
		return index(self)(n)
	}
}

/// Looks up the nth element of a Stream.
public func index<T>(s : Stream<T>) -> UInt -> T {
	return { n in
		if n == 0 {
			return s.step().head
		}
		return index(s.step().tail)(n - 1)
	}
}

/// Returns the first element of a Stream.
public func head<T>(s : Stream<T>) -> T {
	return s.step().head
}

/// Returns the remaining elements of a Stream.
public func tail<T>(s : Stream<T>) -> Stream<T> {
	return s.step().tail
}

/// Returns a Stream of all initial segments of a Stream.
public func inits<T>(s : Stream<T>) -> Stream<[T]> {
	return Stream(([], map({ s.step().head <| $0 })(inits(s.step().tail))))
}

/// Returns a Stream of all final segments of a Stream.
public func tails<T>(s : Stream<T>) -> Stream<Stream<T>> {
	return Stream((s, tails(s.step().tail)))
}

/// Repeats a value into a constant stream of that same value.
public func repeat<T>(x : T) -> Stream<T> {
	return Stream((x, repeat(x)))
}

/// Returns a Stream of an infinite number of iteratations of applications of a function to a value.
public func iterate<T>(f : T -> T) -> T -> Stream<T> {
	return { x in Stream((x, iterate(f)(f(x)))) }
}

/// Cycles a non-empty list into an infinite Stream of repeating values.
///
/// This function is partial with respect to the empty list.
public func cycle<T>(xs : [T]) -> Stream<T> {
	switch match(xs) {
		case .Empty:
			return error("Cannot cycle an empty list.")
		case .Cons(let x, let xs):
			return Stream((x, cycle(xs + [x])))
	}
}

/// Maps a function over a Stream and returns a new Stream of those values.
public func map<A, B>(f : A -> B) -> Stream<A> -> Stream<B> {
	return { s in Stream((f(s.step().head), map(f)(s.step().tail))) }
}

/// Uses function to construct a Stream.
///
/// Unlike unfold for lists, unfolds to construct a Stream have no base case.
public func unfold<A, B>(f : A -> (B, A)) -> A -> Stream<B> {
	return { z in  
		let (x, d) = f(z)
		return Stream((x, unfold(f)(d)))
	}
}

/// Returns a Stream of alternating elements from each Stream.
public func interleave<T>(s1 : Stream<T>) -> Stream<T> -> Stream<T> {
	return { s2 in Stream((s1.step().head, interleave(s2)(s1))) }
}

/// Creates a Stream alternating an element in between the values of another Stream.
public func intersperse<T>(x : T) -> Stream<T> -> Stream<T> {
	return { s in Stream((s.step().head, Stream((x, intersperse(x)(s.step().tail))))) }
}

/// Returns a Stream of successive reduced values.
public func scanl<A, B>(f : A -> B -> A) -> A -> Stream<B> -> Stream<A> {
	return { z in { s in Stream((z, scanl(f)(f(z)(s.step().head))(s.step().tail))) } }
}

/// Returns a Stream of successive reduced values.
public func scanl1<A>(f : A -> A -> A) -> Stream<A> -> Stream<A> {
	return { s in scanl(f)(s.step().head)(s.step().tail) }
}

/// Transposes the "Rows and Columns" of an infinite Stream.
public func transpose<T>(ss : Stream<Stream<T>>) -> Stream<Stream<T>> {
	let xs = ss.step().head
	let yss = ss.step().tail
	return Stream((Stream((xs.step().head, map(head)(yss))), transpose(Stream((xs.step().tail, map(tail)(yss)))))) 
}

/// Returns the first n elements of a Stream.
public func take<T>(n : UInt) -> Stream<T> -> [T] {
	return { s in  
		if n == 0 {
			return []
		}
		return s.step().head <| take(n - 1)(s.step().tail)
	}
}

/// Returns a Stream with the first n elements removed.
public func drop<T>(n : UInt) -> Stream<T> -> Stream<T> {
	return { s in  
		if n == 0 {
			return s
		}
		return drop(n - 1)(tail(s.step().tail))
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
		if p(s.step().head) {
			return s.step().head <| takeWhile(p)(s.step().tail)
		}
		return []
	}
}

/// Returns the longest suffix remaining after a predicate holds.
public func dropWhile<T>(p : T -> Bool) -> Stream<T> -> Stream<T> {
	return { s in 
		if p(s.step().head) {
			return dropWhile(p)(s.step().tail)
		}
		return s
	}
}

/// Removes elements from the Stream that do not satisfy a given predicate.
///
/// If there are no elements that satisfy this predicate this function will diverge.
public func filter<T>(p : T -> Bool) -> Stream<T> -> Stream<T> {
	return { s in 
		if p(s.step().head) {
			return Stream((s.step().head, filter(p)(s.step().tail)))
		}
		return filter(p)(s.step().tail)
	}
}

/// Zips two Streams into a Stream of pairs.
public func zip<A, B>(s1 : Stream<A>) -> Stream<B> -> Stream<(A, B)> {
	return { s2 in Stream(((s1.step().head, s2.step().head), zip(s1.step().tail)(s2.step().tail))) }
}

/// Zips two Streams into a third Stream using a combining function.
public func zipWith<A, B, C>(f : A -> B -> C) -> Stream<A> -> Stream<B> -> Stream<C> {
	return { s1 in { s2 in Stream((f(s1.step().head)(s2.step().head), zipWith(f)(s1.step().tail)(s2.step().tail))) } }
}

/// Unzips a Stream of pairs into a pair of Streams.
public func unzip<A, B>(sp : Stream<(A, B)>) -> (Stream<A>, Stream<B>) {
	return (map(fst)(sp), map(snd)(sp))
}

extension Stream : Functor {
	typealias A = T
	typealias B = Swift.Any
	
	typealias FB = Stream<B>
	
	public static func fmap<B>(f : A -> B) -> Stream<A> -> Stream<B> {
		return map(f)
	}
}

public func <%><A, B>(f : A -> B, b : Stream<A>) -> Stream<B> {
	return Stream.fmap(f)(b)
}

public func <%<A, B>(a : A, _ : Stream<B>) -> Stream<A> {
	return repeat(a)
}

extension Stream : Applicative {
	typealias FAB = Stream<A -> B>
	
	public static func pure(x : A) -> Stream<A> {
		return repeat(x)
	}

	public static func ap<B>(f : Stream<A -> B>) -> Stream<A> -> Stream<B> {
		return { o in f >*< o }
	}
}

public func <*><A, B>(f : Stream<A -> B> , o : Stream<A>) -> Stream<B> {
	return f >*< o
}

public func *><A, B>(a : Stream<A>, b : Stream<B>) -> Stream<B> {
	return a *< b
}

public func <*<A, B>(a : Stream<A>, b : Stream<B>) -> Stream<A> {
	return a >* b
}

extension Stream : ApplicativeOps {
	typealias C = Any
	typealias FC = Stream<C>
	typealias D = Any
	typealias FD = Stream<D>

	public static func liftA<B>(f : A -> B) -> Stream<A> -> Stream<B> {
		return { a in Stream<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Stream<A> -> Stream<B> -> Stream<C> {
		return { a in { b in f <%> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Stream<A> -> Stream<B> -> Stream<C> -> Stream<D> {
		return { a in { b in { c in f <%> a <*> b <*> c } } }
	}
}

extension Stream : Monad {
	public func bind<B>(f : A -> Stream<B>) -> Stream<B> {
		return unfold({ ss in 
			let bs = ss.step().head
			let bss = ss.step().tail
			return (head(bs), map(tail)(bss))
		})(map(f)(self))
	}
}

public func >>-<A, B>(x : Stream<A>, f : A -> Stream<B>) -> Stream<B> {
	return x.bind(f)
}

public func >><A, B>(_ : Stream<A>, bs : Stream<B>) -> Stream<B> {
	return bs
}

extension Stream : MonadOps {
	typealias MLA = Stream<[A]>
	typealias MLB = Stream<[B]>
	typealias MU = Stream<()>

	public static func mapM<B>(f : A -> Stream<B>) -> [A] -> Stream<[B]> {
		return { xs in Stream<B>.sequence(map(f)(xs)) }
	}

	public static func mapM_<B>(f : A -> Stream<B>) -> [A] -> Stream<()> {
		return { xs in Stream<B>.sequence_(map(f)(xs)) }
	}

	public static func forM<B>(xs : [A]) -> (A -> Stream<B>) -> Stream<[B]> {
		return flip(Stream.mapM)(xs)
	}

	public static func forM_<B>(xs : [A]) -> (A -> Stream<B>) -> Stream<()> {
		return flip(Stream.mapM_)(xs)
	}

	public static func sequence(ls : [Stream<A>]) -> Stream<[A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in Stream<[A]>.pure(cons(x)(xs)) } } })(Stream<[A]>.pure([]))(ls)
	}

	public static func sequence_(ls : [Stream<A>]) -> Stream<()> {
		return foldr(>>)(Stream<()>.pure(()))(ls)
	}
}

public func -<<<A, B>(f : A -> Stream<B>, xs : Stream<A>) -> Stream<B> {
	return xs.bind(f)
}

public func >-><A, B, C>(f : A -> Stream<B>, g : B -> Stream<C>) -> A -> Stream<C> {
	return { x in f(x) >>- g }
}

public func <-<<A, B, C>(g : B -> Stream<C>, f : A -> Stream<B>) -> A -> Stream<C> {
	return { x in f(x) >>- g }
}

extension Stream : Copointed {
	public func extract() -> A {
		return head(self)
	}
}

extension Stream : Comonad {
	typealias FFA = Stream<Stream<A>>
	
	public static func duplicate(b : Stream<A>) -> Stream<Stream<A>> {
		return tails(b)
	}
	
	
	public static func extend<B>(f : Stream<A> -> B) -> Stream<A> -> Stream<B> {
		return { b in 
			return Stream<B>((f(b), Stream.extend(f)(tail(b))))
		}
	}
}

extension Stream : ComonadApply {}

public func >*<<A, B>(fab : Stream<A -> B> , xs : Stream<A>) -> Stream<B> {
	let f = fab.step().head
	let fs = fab.step().tail
	let x = xs.step().head
	let xss = xs.step().tail 
	return Stream((f(x), (fs >*< xss)))
}

public func *<<A, B>(_ : Stream<A>, b : Stream<B>) -> Stream<B> {
	return b
}

public func >*<A, B>(a : Stream<A>, _ : Stream<B>) -> Stream<A> {
	return a
}

