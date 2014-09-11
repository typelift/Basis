//
//  Foldable.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Foldable {
	typealias A
	typealias M : Monoid
	
	typealias TA = K1<A>
	typealias TM = K1<M>
	
	func fold<M : Monoid>(TM) -> M
	func foldMap<M : Monoid>(A -> M) -> TA -> M
}
