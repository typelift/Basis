//
//  ScansSpec.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 9/26/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Basis
import XCTest

class ScansSpec : XCTestCase {
	func testScanl() {
		let withArray = [1,2,3,4]
		let scanned = scanl(+)(0)(withArray)

		XCTAssert(scanned == [0,1,3,6,10], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}

	func testIntersperse() {
		let withArray = [1,2,3,4]
		let inter = intersperse(1)(withArray)

		XCTAssert(inter == [1,1,2,1,3,1,4], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")

		let single = [1]
		XCTAssert(intersperse(1)(single) == [1], "Should be equal")
	}

	func testSplitAt() {
		let withArray = [1,2,3,4]

		let tuple = splitAt(2)(withArray)

		XCTAssert(tuple.0 == [1,2] && tuple.1 == [3,4], "Should be equal")

		XCTAssert(splitAt(0)(withArray).0 == Array() && splitAt(0)(withArray).1 == [1,2,3,4], "Should be equal")
		XCTAssert(withArray == [1,2,3,4], "Should be equal(immutablility test)")
	}

}
