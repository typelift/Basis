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
		switch destruct(l) {
			case .Empty:
				return []
			case .Destructure(let a, let as_):
				switch destruct(l2) {
					case .Empty:
						return []
					case .Destructure(let b, let bs):
						return (a, b) <| zip(as_)(bs)
				}
		}
	}
}

/// Zips three lists into an array of triples.
public func zip3<A, B, C>(l : [A]) -> [B] -> [C] -> [(A, B, C)] {
	return { l2 in { l3 in
		switch destruct(l) {
			case .Empty:
				return []
			case .Destructure(let a, let as_):
				switch destruct(l2) {
					case .Empty:
						return []
					case .Destructure(let b, let bs):
						switch destruct(l3) {
						case .Empty:
							return []
						case .Destructure(let c, let cs):
							return (a, b, c) <| zip3(as_)(bs)(cs)
						}
				}
		}
	} }
}

/// Zips together the elements of two lists according to a combining function.
public func zipWith<A, B, C>(f : A -> B -> C) -> [A] -> [B] -> [C] {
	return { l in { l2 in
		switch destruct(l) {
			case .Empty:
				return []
			case .Destructure(let a, let as_):
				switch destruct(l2) {
					case .Empty:
						return []
					case .Destructure(let b, let bs):
						return f(a)(b) <| zipWith(f)(as_)(bs)
				}
		}
	} }
}

/// Zips together the elements of two lists according to a combining operator.
public func zipWith<A, B, C>(f : (A, B) -> C) -> [A] -> [B] -> [C] {
	return { l in { l2 in
		switch destruct(l) {
			case .Empty:
				return []
			case .Destructure(let a, let as_):
				switch destruct(l2) {
					case .Empty:
						return []
					case .Destructure(let b, let bs):
						return f(a, b) <| zipWith(f)(as_)(bs)
				}
		}
	} }
}

/// Unzips an array of tuples into a tuple of arrays.
public func unzip<A, B>(l : [(A, B)]) -> ([A], [B]) {
	var arra : [A] = []
	var arrb : [B] = []
	for (x, y) in l {
		arra += [x]
		arrb += [y]
	}
	return (arra, arrb)
}

/// Unzips an array of triples into a triple of arrays.
public func unzip3<A, B, C>(l : [(A, B, C)]) -> ([A], [B], [C]) {
	var arra : [A] = []
	var arrb : [B] = []
	var arrc : [C] = []
	for (x, y, z) in l {
		arra += [x]
		arrb += [y]
		arrc += [z]
	}
	return (arra, arrb, arrc)
}

