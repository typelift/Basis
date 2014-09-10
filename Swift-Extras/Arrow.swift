//
//  Arrow.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

infix operator *** {}
infix operator &&& {}

public protocol Arrow : Category {
	typealias AB
	typealias AC
	
	typealias D
	typealias E
	
	typealias ABC = K2<AB, AC>
	typealias FIRST = K2<(AB, D), (AC, D)>
	typealias SECOND = K2<(D, AB), (D, AC)>
	
	typealias ADE = K2<D, E>
	typealias SPLIT = K2<(AB, D), (AC, E)>
	
	
	typealias ABD = K2<AB, D>
	typealias FANOUT = K2<B, (AC, D)>
	
	class func arr(AB -> AC) -> ABC
	func first() -> FIRST
	func second() -> SECOND
	
	func ***(ABC, ADE) -> SPLIT
	func &&&(ABC, ABD) -> FANOUT
}

public protocol ArrowZero : Arrow {
	class func zeroArrow() -> ABC
}
