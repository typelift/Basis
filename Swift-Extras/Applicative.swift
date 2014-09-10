//
//  Applicative.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Applicative : Functor {
	typealias FAB = K1<A -> B>
	class func pure(A) -> Self
	
	func <*>(FAB , Self) -> FB
	func *>(Self, FB) -> FB
	func <*(Self, FB) -> Self
}
