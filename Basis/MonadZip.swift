//
//  MonadZip.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

/// Monads that allow zipping.
public protocol MonadZip : Monad {
	/// An arbitrary domain.  Usually Any
	typealias C
	/// A monad with an arbitrary domain.
	typealias FC = K1<C>

	/// A Monad containing a zipped tuple.
	typealias FTAB = K1<(A, B)>
	
	/// Zip for monads.
	func mzip(FA) -> FB -> FTAB
	
	/// ZipWith for monads.
	func mzipWith(A -> B -> C) -> FA -> FB -> FC
	
	/// Unzip for monads.
	func munzip(FTAB) -> (FA, FB)
}

