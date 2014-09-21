//
//  FunctionSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Basis
import XCTest

class FunctionSpec : XCTestCase {
	func function1(x : Int) -> Int {
		return x + 1
	}
	
	func function2(x : Int, y : Int) -> Int {
		return x + y
	}
	
	func testFunction() {
		let suc = ^(function1)
		
		XCTAssertTrue(suc.apply(0) == 1, "")
		XCTAssertTrue(suc.apply(suc.apply(0)) == 2, "")
		XCTAssertTrue(suc.apply(suc.apply(suc.apply(0))) == 3, "")
		XCTAssertTrue(suc.apply(suc.apply(suc.apply(suc.apply(0)))) == 4, "")
	}
	
	func testFunction2() {
		let plus = ^(function2)

		XCTAssertTrue(plus.apply((0, 0)) == 0, "")
		XCTAssertTrue(plus.apply((2, 2)) == 4, "")
		XCTAssertTrue(plus.apply((2, 3)) == 5, "")
		XCTAssertTrue(plus.apply((4000, 6000)) == 10000, "")
	}
}
