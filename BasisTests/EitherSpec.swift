//
//  EitherSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class EitherSpec : XCTestCase {
	func testEither() {
		let l = { $0 + 25 }
		let r = { $0 + 10 }

		let left = Either<Int, Int>.left(10)
		let right = Either<Int, Int>.right(10)

		XCTAssertTrue(either(l)(r)(left) == 35, "")
		XCTAssertTrue(either(l)(r)(right) == 20, "")
	}
}

