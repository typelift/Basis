//
//  Functor.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

infix operator <^ {}

public protocol Functor {
	typealias A
	typealias B
	typealias FB = K1<B>
	
	func fmap(A -> B) -> Self -> FB
	func <^(A, FB) -> Self
}

public func defaultReplace<A, B, FA : Functor, FB : Functor>(fmap : (A -> B) -> FA -> FB)(x : B)(f : FA) -> FB {
	return (fmap • const)(x)(f)
}

