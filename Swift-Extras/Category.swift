//
//  Category.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Category {
	typealias A
	typealias B
	typealias C

	typealias CAA = K2<A, A>
	typealias CAB = K2<A, B>
	typealias CBC = K2<B, C>
	typealias CAC = K2<A, C>

	func id() -> CAA
	func •(c : CBC, c2 : CAB) -> CAC
	
	func <<< (CBC, CAB) -> CAC
	func >>> (CAB, CBC) -> CAC
}
