//
//  Infinity.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift

public func iterate<A>(f : A -> A)(x : A) -> LazySequenceOf<Iterate<A>, A> {
	return LazySequenceOf(Iterate(ini: x, iter: f))
}

public func repeat<A>(x : A) -> LazySequenceOf<Iterate<A>, A> {
	return LazySequenceOf(Iterate(ini: x, iter: id))
}

public func replicate<A>(n : Int)(x : A) -> [A] {
	return Array(count: n, repeatedValue: x)
}

public func cycle<A>(x : [A]) -> LazySequenceOf<Cycle<A>, A> {
	return LazySequenceOf(Cycle(ini: x))
}


public class Iterate<A> : SequenceType {
	typealias GeneratorType = IterateGenerator<A>
	
	let initial : A
	let iter : A -> A
	
	init(ini : A, iter : A -> A) {
		self.initial = ini
		self.iter = iter
	}
	
	public func generate() -> IterateGenerator<A> {
		return IterateGenerator<A>(ini: initial, iter)
	}
}

public class IterateGenerator<A> : GeneratorType {
	var current : A
	var nextValue : A
	var iter : A -> A
	
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

public class Cycle<A> : SequenceType {
	typealias GeneratorType = CycleGenerator<A>
	
	let arr : [A]
	
	init(ini : [A]) {
		self.arr = ini
	}
	
	public func generate() -> CycleGenerator<A> {
		return CycleGenerator<A>(arr: arr)
	}
}

public class CycleGenerator<A> : GeneratorType {
	var arr : [A]
	var index : Int
	
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
