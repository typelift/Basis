//
//  Tuple.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func fst<A, B>(t : (A, B)) -> A {
	return t.0
}

public func snd<A, B>(t : (A, B)) -> B {
	return t.1
}

public func curry<A, B, C>(f : (A, B) -> C) ->  A -> B -> C {
	return { (let a) in
		return { (let b) in
			return f((a, b))
		}
	}
}

public func uncurry<A, B, C>(f : A -> B -> C) -> (A, B) -> C {
	return { (let t) in
		return f(t.0)(t.1)
	}
}

public func swap<A, B>(t : (A, B)) -> (B, A) {
	return (t.1, t.0)
}

