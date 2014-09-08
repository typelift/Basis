//
//  Lazy.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public struct LazySequenceOf<S : SequenceType, A where S.Generator.Element == A> : SequenceType {
	let seq : S
	public init(_ seq : S) {
		self.seq = seq
	}
	
	public func generate() -> GeneratorOf<A> {
		return GeneratorOf(seq.generate())
	}
	
	public subscript(i : Int) -> A {
		var gen = self.generate()
		var res : A? = gen.next()
		for x in 0..<i {
			res = gen.next()

		}
		return res!
	}
}
