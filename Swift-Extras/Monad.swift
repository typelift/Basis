//
//  Monad.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Monad : Applicative {
	func bind<B, MB : Monad where MB : K1<B>>(f : A -> MB) -> MB
}
