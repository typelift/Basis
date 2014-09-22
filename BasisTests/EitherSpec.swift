//
//  EitherSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

#if os(OSX)
import Basis
#else
import MobileBasis
#endif
import XCTest


class EitherSpec : XCTestCase {
	func testEither() {
		let l = { $0 + 25 }
		let r = { $0 + 10 }

		let left = Either<Int, Int>.left(10)
		let right = Either<Int, Int>.right(10)

		XCTAssertTrue(either(l)(right: r)(e: left) == 35, "")
		XCTAssertTrue(either(l)(right: r)(e: right) == 20, "")
	}
}

