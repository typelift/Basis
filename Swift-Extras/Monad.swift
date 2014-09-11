//
//  Monad.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Monad : Applicative {
	typealias MB : K1<B>
	
	func bind(f : A -> MB) -> MB
}
