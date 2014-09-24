//
//  Coerce.swift
//  Basis
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// The highly unsafe primitive unsafeCoerce converts a value from any type to any other type. 
/// Needless to say, if you use this function, it is your responsibility to ensure that the old and
/// new types have identical internal representations, in order to prevent runtime corruption.
/// ~http://hackage.haskell.org/package/base-4.7.0.1/docs/Unsafe-Coerce.html
public func unsafeCoerce<A, B>(x : A) -> B {
	return unsafeBitCast(x, B.self)
}
