//
//  File.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol MonadFix : Monad {
	func mfix(f : A -> FA) -> FA
}

