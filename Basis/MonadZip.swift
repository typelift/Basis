//
//  MonadZip.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Monads that allow zipping.
public protocol MonadZip : Monad {
	/// An arbitrary domain.  Usually Any
	associatedtype C
	/// A monad with an arbitrary domain.
	associatedtype FC = K1<C>

	/// A Monad containing a zipped tuple.
	associatedtype FTAB = K1<(A, B)>
	
	/// Zip for monads.
	func mzip(_: Self) -> FB -> FTAB
	
	/// ZipWith for monads.
	func mzipWith(_: A -> B -> C) -> Self -> FB -> FC
	
	/// Unzip for monads.
	func munzip(_: FTAB) -> (Self, FB)
}

