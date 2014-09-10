//
//  Coerce.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func unsafeCoerce<A, B>(x : A) -> B {
	return unsafeBitCast(x, B.self)
}
