//
//  Infinity.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift

/// Returns an infinite list of repeated applications of a function to a value x.
///
///     iterate(f)(x) == [x, f(x), f(f(x)), ...]
public func iterate<A>(f : A -> A)(x : A) -> LazySequenceOf<Iterate<A>, A> {
	return LazySequenceOf(Iterate(ini: x, iter: f))
}

/// Generates an infinite list with x as every value.
public func repeat<A>(x : A) -> LazySequenceOf<Iterate<A>, A> {
	return LazySequenceOf(Iterate(ini: x, iter: id))
}

/// Returns a list with n values of x in it.
public func replicate<A>(n : Int)(x : A) -> [A] {
	return Array(count: n, repeatedValue: x)
}

/// Cycles a finite list into an infinite list.
public func cycle<A>(x : [A]) -> LazySequenceOf<Cycle<A>, A> {
	return LazySequenceOf(Cycle(ini: x))
}


public final class Iterate<A> : SequenceType {
	typealias GeneratorType = IterateGenerator<A>
	
	private let initial : A
	private let iter : A -> A
	
	init(ini : A, iter : A -> A) {
		self.initial = ini
		self.iter = iter
	}
	
	public func generate() -> IterateGenerator<A> {
		return IterateGenerator<A>(ini: initial, iter)
	}
}

public final class IterateGenerator<A> : GeneratorType {
	private var current : A
	private var nextValue : A
	private var iter : A -> A
	
	init(ini : A, iter : A -> A) {
		self.current = ini
		self.nextValue = iter(ini)
		self.iter = iter
	}
	
	public func next() -> A? {
		let ret = current
		current = nextValue
		nextValue = iter(current)
		return ret
	}
}

public final class Cycle<A> : SequenceType {
	typealias GeneratorType = CycleGenerator<A>
	
	private let arr : [A]
	
	init(ini : [A]) {
		self.arr = ini
	}
	
	public func generate() -> CycleGenerator<A> {
		return CycleGenerator<A>(arr: arr)
	}
}

public final class CycleGenerator<A> : GeneratorType {
	private var arr : [A]
	private var index : Int
	
	init(arr : [A]) {
		self.arr = arr
		self.index = 0
	}
	
	public func next() -> A? {
		let ret = self.arr[index]
		index = (index + 1 == arr.count) ? 0 : index + 1
		return ret
	}
}
