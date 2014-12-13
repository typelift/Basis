//
//  Zip.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Zips two lists into an array of pairs.
public func zip<A, B>(l : [A]) -> [B] -> [(A, B)] {
	return { l2 in
		switch (destruct(l), destruct(l2)) {
			case (.Cons(let a, let as_), .Cons(let b, let bs)):
				return (a, b) <| zip(as_)(bs)
			default:
				return []
		}
	}
}

/// Zips three lists into an array of triples.
public func zip3<A, B, C>(l : [A]) -> [B] -> [C] -> [(A, B, C)] {
	return { l2 in { l3 in
		switch (destruct(l), destruct(l2), destruct(l3)) {
			case (.Cons(let a, let as_), .Cons(let b, let bs), .Cons(let c, let cs)):
				return (a, b, c) <| zip3(as_)(bs)(cs)
			default:
				return []
		}
	} }
}

/// Zips together the elements of two lists according to a combining function.
public func zipWith<A, B, C>(f : A -> B -> C) -> [A] -> [B] -> [C] {
	return { l in { l2 in
		switch (destruct(l), destruct(l2)) {
			case (.Cons(let a, let as_), .Cons(let b, let bs)):
				return f(a)(b) <| zipWith(f)(as_)(bs)
			default:
				return []
		}
	} }
}

/// Zips together the elements of two lists according to a combining operator.
public func zipWith<A, B, C>(f : (A, B) -> C) -> [A] -> [B] -> [C] {
	return { l in { l2 in
		switch (destruct(l), destruct(l2)) {
			case (.Cons(let a, let as_), .Cons(let b, let bs)):
				return f(a, b) <| zipWith(f)(as_)(bs)
			default:
				return []
		}
	} }
}

/// Zips together the elements of three lists according to a combining function.
public func zipWith3<A, B, C, D>(f : A -> B -> C -> D) -> [A] -> [B] -> [C] -> [D] {
	return { l in { l2 in { l3 in
		switch (destruct(l), destruct(l2), destruct(l3)) {
			case (.Cons(let a, let as_), .Cons(let b, let bs), .Cons(let c, let cs)):
				return f(a)(b)(c) <| zipWith3(f)(as_)(bs)(cs)
			default:
				return []
		}
	} } }
}

/// Unzips an array of tuples into a tuple of arrays.
public func unzip<A, B>(l : [(A, B)]) -> ([A], [B]) {
	switch destruct(l) {
		case .Empty:
			return ([], [])
		case .Cons(let (a, b), let tl):
			let (t1, t2) : ([A], [B]) = unzip(tl)
			return (a <| t1, b <| t2)
	}
}

/// Unzips an array of triples into a triple of arrays.
public func unzip3<A, B, C>(l : [(A, B, C)]) -> ([A], [B], [C]) {
	switch destruct(l) {
		case .Empty:
			return ([], [], [])
		case .Cons(let (a, b, c), let tl):
			let (t1, t2, t3) : ([A], [B], [C]) = unzip3(tl)
			return (a <| t1, b <| t2, c <| t3)
	}
}

