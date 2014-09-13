//
//  MonadZip.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol MonadZip : Monad {
	typealias C
	typealias FC = K1<C>

	typealias FTAB = K1<(A, B)>
	
	func mzip(FA) -> FB -> FTAB
	func mzipWith(A -> B -> C) -> FA -> FB -> FC
	func munzip(FTAB) -> (FA, FB)
}

