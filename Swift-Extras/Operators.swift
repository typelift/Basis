//
//  Operators.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

infix operator <| {
	associativity right
}

infix operator |> {
associativity right
}

infix operator • {
	associativity left
}


public func <|<A, B>(f : A -> B, x : A) -> B {
	return f(x)
}

public func |><A, B>(x : A, f : A -> B) -> B {
	return f(x)
}

public func •<A, B, C>(f : B -> C, g : A -> B) -> A -> C {
	return { f(g($0)) }
}
