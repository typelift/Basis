//
//  Equality.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/17/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public class PropositionalEquality<A, B> : K2<A, B> {
	
}


public func apply<A, B, C>(ab : PropositionalEquality<A, B>, bc : PropositionalEquality<B, C>) -> PropositionalEquality<A, C> {
	
}