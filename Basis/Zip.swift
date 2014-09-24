//
//  Zip.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Zips two lists into an array of pairs.
public func zip<A, B>(l : [A])(l2 : [B]) -> [(A, B)] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let a, let as_):
			switch l2.destruct() {
				case .Empty:
					return []
				case .Destructure(let b, let bs):
					return (a, b) +> zip(as_)(l2: bs)
			}
	}
}

/// Zips three lists into an array of triples.
public func zip3<A, B, C>(l : [A])(l2 : [B])(l3 : [C]) -> [(A, B, C)] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let a, let as_):
			switch l2.destruct() {
				case .Empty:
					return []
				case .Destructure(let b, let bs):
					switch l3.destruct() {
					case .Empty:
						return []
					case .Destructure(let c, let cs):
						return (a, b, c) +> zip3(as_)(l2: bs)(l3: cs)
				}
		}
	}
}

/// Zips together the elements of two lists according to a combining function.
public func zipWith<A, B, C>(f : A -> B -> C)(l : [A])(l2 : [B]) -> [C] {
	switch l.destruct() {
	case .Empty:
		return []
	case .Destructure(let a, let as_):
		switch l2.destruct() {
			case .Empty:
				return []
			case .Destructure(let b, let bs):
				return f(a)(b) +> zipWith(f)(l: as_)(l2: bs)
		}
	}
}

/// Zips together the elements of two lists according to a combining operator.
public func zipWith<A, B, C>(f : (A, B) -> C)(l : [A])(l2 : [B]) -> [C] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let a, let as_):
			switch l2.destruct() {
				case .Empty:
					return []
				case .Destructure(let b, let bs):
					return f(a, b) +> zipWith(f)(l: as_)(l2: bs)
			}
	}
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

