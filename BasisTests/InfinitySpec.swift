//
//  InfinitySpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class InfinitySpec : XCTestCase {
	func testIterate() {
		let arr = iterate({ 1 + $0 })(0)
		
		XCTAssertTrue(arr[0] == 0, "")
		XCTAssertTrue(arr[1] == 1, "")
		XCTAssertTrue(arr[2] == 2, "")
		XCTAssertTrue(arr[3] == 3, "")
		XCTAssertTrue(arr[4] == 4, "")
		XCTAssertTrue(arr[5] == 5, "")
	}
	
	func testRepeat() {
		let arr = `repeat`("rada")
		
		XCTAssertTrue(arr[0] == "rada", "")
		XCTAssertTrue(arr[1] == "rada", "")
		XCTAssertTrue(arr[2] == "rada", "")
		XCTAssertTrue(arr[3] == "rada", "")
		XCTAssertTrue(arr[4] == "rada", "")
		XCTAssertTrue(arr[5] == "rada", "")
	}
	
	func testCycle() {
		let arr = cycle(["You", "Say", "Goodbye"])
		
		XCTAssertTrue(arr[0] == "You", "")
		XCTAssertTrue(arr[1] == "Say", "")
		XCTAssertTrue(arr[2] == "Goodbye", "")
		XCTAssertTrue(arr[3] == "You", "")
		XCTAssertTrue(arr[4] == "Say", "")
		XCTAssertTrue(arr[5] == "Goodbye", "")
	}
}
