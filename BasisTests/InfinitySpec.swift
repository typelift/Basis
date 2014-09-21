//
//  InfinitySpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Basis
import XCTest

class InfinitySpec : XCTestCase {
	func testIterate() {
		let arr = iterate({ 1 + $0 })(x: 0)
		
		XCTAssertTrue(arr[0] == 0, "")
		XCTAssertTrue(arr[1] == 1, "")
		XCTAssertTrue(arr[2] == 2, "")
		XCTAssertTrue(arr[3] == 3, "")
		XCTAssertTrue(arr[4] == 4, "")
		XCTAssertTrue(arr[5] == 5, "")
	}
	
	func testRepeat() {
		let arr = repeat("rada")
		
		XCTAssertTrue(arr[0] == "rada", "")
		XCTAssertTrue(arr[1] == "rada", "")
		XCTAssertTrue(arr[2] == "rada", "")
		XCTAssertTrue(arr[3] == "rada", "")
		XCTAssertTrue(arr[4] == "rada", "")
		XCTAssertTrue(arr[5] == "rada", "")
	}
	
	func testReplicate() {
		let arr = replicate(5)(x: "Hello")
		
		XCTAssertTrue(arr[0] == "Hello", "")
		XCTAssertTrue(arr[1] == "Hello", "")
		XCTAssertTrue(arr[2] == "Hello", "")
		XCTAssertTrue(arr[3] == "Hello", "")
		XCTAssertTrue(arr[4] == "Hello", "")
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

