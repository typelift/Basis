//
//  File.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Monads that admit left-tightening recursion.
public protocol MonadFix : Monad {
	/// Calculates the fixed point of a monadic computation.
	func mfix(A -> FA) -> FA
}

// Uncomment to crash Swiftc
//extension Optional : MonadFix {
//	public func mfix(f : A -> Optional<A>) -> Optional<A> {
//		return f(fromSome(mfix(f)))
//	}
//}
