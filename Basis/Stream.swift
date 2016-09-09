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
	let step : () -> (head : T, tail : Stream<T>)
	
	init(_ step : @escaping () -> (head : T, tail : Stream<T>)) {
		self.step = step
	}
	
	public subscript(n : UInt) -> T {
		return index(self)(n)
	}
}

/// Looks up the nth element of a Stream.
public func index<T>(_ s : Stream<T>) -> (UInt) -> T {
	return { n in
		if n == 0 {
			return s.step().head
		}
		return index(s.step().tail)(n - 1)
	}
}

/// Returns the first element of a Stream.
public func head<T>(_ s : Stream<T>) -> T {
	return s.step().head
}

/// Returns the remaining elements of a Stream.
public func tail<T>(_ s : Stream<T>) -> Stream<T> {
	return s.step().tail
}

/// Returns a Stream of all initial segments of a Stream.
public func inits<T>(_ s : Stream<T>) -> Stream<[T]> {
	return Stream { ([], map({ s.step().head <<| $0 })(inits(s.step().tail))) }
}

/// Returns a Stream of all final segments of a Stream.
public func tails<T>(_ s : Stream<T>) -> Stream<Stream<T>> {
	return Stream { (s, tails(s.step().tail)) }
}

/// Repeats a value into a constant stream of that same value.
public func `repeat`<T>(_ x : T) -> Stream<T> {
	return Stream { (x, `repeat`(x)) }
}

/// Returns a Stream of an infinite number of iteratations of applications of a function to a value.
public func iterate<T>(_ f : @escaping (T) -> T) -> (T) -> Stream<T> {
	return { x in Stream { (x, iterate(f)(f(x))) } }
}

/// Cycles a non-empty list into an infinite Stream of repeating values.
///
/// This function is partial with respect to the empty list.
public func cycle<T>(_ xs : [T]) -> Stream<T> {
	switch match(xs) {
		case .nil:
			return error("Cannot cycle an empty list.")
		case .cons(let x, let xs):
			return Stream { (x, cycle(xs + [x])) }
	}
}

/// Maps a function over a Stream and returns a new Stream of those values.
public func map<A, B>(_ f : @escaping (A) -> B) -> (Stream<A>) -> Stream<B> {
	return { s in Stream { (f(s.step().head), map(f)(s.step().tail)) } }
}

/// Uses function to construct a Stream.
///
/// Unlike unfold for lists, unfolds to construct a Stream have no base case.
public func unfold<A, B>(_ f : @escaping (A) -> (B, A)) -> (A) -> Stream<B> {
	return { z in  
		let (x, d) = f(z)
		return Stream { (x, unfold(f)(d)) }
	}
}

/// Returns a Stream of alternating elements from each Stream.
public func interleave<T>(_ s1 : Stream<T>) -> (Stream<T>) -> Stream<T> {
	return { s2 in Stream { (s1.step().head, interleave(s2)(s1)) } }
}

/// Creates a Stream alternating an element in between the values of another Stream.
public func intersperse<T>(_ x : T) -> (Stream<T>) -> Stream<T> {
	return { s in Stream { (s.step().head, Stream { (x, intersperse(x)(s.step().tail)) } ) } }
}

/// Returns a Stream of successive reduced values.
public func scanl<A, B>(_ f : @escaping (A) -> (B) -> A) -> (A) -> (Stream<B>) -> Stream<A> {
	return { z in { s in Stream { (z, scanl(f)(f(z)(s.step().head))(s.step().tail)) } } }
}

/// Returns a Stream of successive reduced values.
public func scanl1<A>(_ f : @escaping (A) -> (A) -> A) -> (Stream<A>) -> Stream<A> {
	return { s in scanl(f)(s.step().head)(s.step().tail) }
}

/// Transposes the "Rows and Columns" of an infinite Stream.
public func transpose<T>(_ ss : Stream<Stream<T>>) -> Stream<Stream<T>> {
	let xs = ss.step().head
	let yss = ss.step().tail
	return Stream { (Stream { (xs.step().head, map(head)(yss)) }, transpose(Stream { (xs.step().tail, map(tail)(yss)) } )) }
}

/// Returns the first n elements of a Stream.
public func take<T>(_ n : UInt) -> (Stream<T>) -> [T] {
	return { s in  
		if n == 0 {
			return []
		}
		return s.step().head <<| take(n - UInt(1))(s.step().tail)
	}
}

/// Returns a Stream with the first n elements removed.
public func drop<T>(_ n : UInt) -> (Stream<T>) -> Stream<T> {
	return { s in  
		if n == 0 {
			return s
		}
		return drop(n - 1)(tail(s.step().tail))
	}
}

/// Returns a pair of the first n elements and the remaining eleemnts in a Stream.
public func splitAt<T>(_ n : UInt) -> (Stream<T>) -> ([T], Stream<T>) {
	return { xs in 
		if n == 0 {
			return ([], xs)
		}
		let (p, r) = splitAt(n - 1)(tail(xs))
		return (head(xs) <<| p, r)
	}
}

/// Returns the longest prefix of values in a Stream for which a predicate holds.
public func takeWhile<T>(_ p : @escaping (T) -> Bool) -> (Stream<T>) -> [T] {
	return { s in 
		if p(s.step().head) {
			return s.step().head <<| takeWhile(p)(s.step().tail)
		}
		return []
	}
}

/// Returns the longest suffix remaining after a predicate holds.
public func dropWhile<T>(_ p : @escaping (T) -> Bool) -> (Stream<T>) -> Stream<T> {
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
public func filter<T>(_ p : @escaping (T) -> Bool) -> (Stream<T>) -> Stream<T> {
	return { s in 
		if p(s.step().head) {
			return Stream { (s.step().head, filter(p)(s.step().tail)) }
		}
		return filter(p)(s.step().tail)
	}
}

/// Zips two Streams into a Stream of pairs.
public func zip<A, B>(_ s1 : Stream<A>) -> (Stream<B>) -> Stream<(A, B)> {
	return { s2 in Stream { ((s1.step().head, s2.step().head), zip(s1.step().tail)(s2.step().tail)) } }
}

/// Zips two Streams into a third Stream using a combining function.
public func zipWith<A, B, C>(_ f : @escaping (A) -> (B) -> C) -> (Stream<A>) -> (Stream<B>) -> Stream<C> {
	return { s1 in { s2 in Stream { (f(s1.step().head)(s2.step().head), zipWith(f)(s1.step().tail)(s2.step().tail)) } } }
}

/// Unzips a Stream of pairs into a pair of Streams.
public func unzip<A, B>(_ sp : Stream<(A, B)>) -> (Stream<A>, Stream<B>) {
	return (map(fst)(sp), map(snd)(sp))
}

extension Stream : Functor {
	public typealias A = T
	public typealias B = Any
	
	public typealias FB = Stream<B>
	
	public static func fmap<B>(_ f : @escaping (A) -> B) -> (Stream<A>) -> Stream<B> {
		return map(f)
	}
}

public func <^> <A, B>(f : @escaping (A) -> B, b : Stream<A>) -> Stream<B> {
	return Stream.fmap(f)(b)
}

public func <% <A, B>(a : A, _ : Stream<B>) -> Stream<A> {
	return `repeat`(a)
}

public func %> <A, B>(c : Stream<B>, a : A) -> Stream<A> {
	return flip(<%)(c, a)
}

extension Stream : Applicative {
	public typealias FAB = Stream<(A) -> B>
	
	public static func pure(_ x : A) -> Stream<A> {
		return `repeat`(x)
	}

	public static func ap<B>(_ f : Stream<(A) -> B>) -> (Stream<A>) -> Stream<B> {
		return { o in f >*< o }
	}
}

public func <*> <A, B>(f : Stream<(A) -> B> , o : Stream<A>) -> Stream<B> {
	return f >*< o
}

public func *> <A, B>(a : Stream<A>, b : Stream<B>) -> Stream<B> {
	return a *< b
}

public func <* <A, B>(a : Stream<A>, b : Stream<B>) -> Stream<A> {
	return a >* b
}

extension Stream : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Stream<C>
	public typealias D = Any
	public typealias FD = Stream<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Stream<A>) -> Stream<B> {
		return { a in Stream<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Stream<A>) -> (Stream<B>) -> Stream<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Stream<A>) -> (Stream<B>) -> (Stream<C>) -> Stream<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Stream : Monad {
	public func bind<B>(_ f : @escaping (A) -> Stream<B>) -> Stream<B> {
		return unfold({ ss in 
			let bs = ss.step().head
			let bss = ss.step().tail
			return (head(bs), map(tail)(bss))
		})(map(f)(self))
	}
}

public func >>- <A, B>(x : Stream<A>, f : @escaping (A) -> Stream<B>) -> Stream<B> {
	return x.bind(f)
}

public func >> <A, B>(_ : Stream<A>, bs : Stream<B>) -> Stream<B> {
	return bs
}

extension Stream : MonadOps {
	public typealias MLA = Stream<[A]>
	public typealias MLB = Stream<[B]>
	public typealias MU = Stream<()>

	public static func mapM<B>(_ f : @escaping (A) -> Stream<B>) -> ([A]) -> Stream<[B]> {
		return { xs in Stream<B>.sequence(map(f)(xs)) }
	}

	public static func mapM_<B>(_ f : @escaping (A) -> Stream<B>) -> ([A]) -> Stream<()> {
		return { xs in Stream<B>.sequence_(map(f)(xs)) }
	}

	public static func forM<B>(_ xs : [A]) -> (@escaping (A) -> Stream<B>) -> Stream<[B]> {
		return flip(Stream.mapM)(xs)
	}

	public static func forM_<B>(_ xs : [A]) -> (@escaping (A) -> Stream<B>) -> Stream<()> {
		return flip(Stream.mapM_)(xs)
	}

	public static func sequence(_ ls : [Stream<A>]) -> Stream<[A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in Stream<[A]>.pure(cons(x)(xs)) } } })(Stream<[A]>.pure([]))(ls)
	}

	public static func sequence_(_ ls : [Stream<A>]) -> Stream<()> {
		return foldr(>>)(Stream<()>.pure(()))(ls)
	}
}

public func -<< <A, B>(f : @escaping (A) -> Stream<B>, xs : Stream<A>) -> Stream<B> {
	return xs.bind(f)
}

public func >>->> <A, B, C>(f : @escaping (A) -> Stream<B>, g : @escaping (B) -> Stream<C>) -> (A) -> Stream<C> {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> Stream<C>, f : @escaping (A) -> Stream<B>) -> (A) -> Stream<C> {
	return { x in f(x) >>- g }
}

extension Stream : Copointed {
	public func extract() -> A {
		return head(self)
	}
}

extension Stream : Comonad {
	public typealias FFA = Stream<Stream<A>>
	
	public static func duplicate(_ b : Stream<A>) -> Stream<Stream<A>> {
		return tails(b)
	}
	
	
	public static func extend<B>(_ f : @escaping (Stream<A>) -> B) -> (Stream<A>) -> Stream<B> {
		return { b in 
			return Stream<B> { (f(b), Stream.extend(f)(tail(b))) }
		}
	}
}

extension Stream : ComonadApply {}

public func >*< <A, B>(fab : Stream<(A) -> B> , xs : Stream<A>) -> Stream<B> {
	let f = fab.step().head
	let fs = fab.step().tail
	let x = xs.step().head
	let xss = xs.step().tail 
	return Stream { (f(x), (fs >*< xss)) }
}

public func *< <A, B>(_ : Stream<A>, b : Stream<B>) -> Stream<B> {
	return b
}

public func >* <A, B>(a : Stream<A>, _ : Stream<B>) -> Stream<A> {
	return a
}

