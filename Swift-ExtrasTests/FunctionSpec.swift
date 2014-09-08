//
//  FunctionSpec.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift_Extras
import XCTest

class FunctionSpec : XCTestCase {
	func function1(x : Int) -> Int {
		return x + 1
	}
	
	func function2(x : Int, y : Int) -> Int {
		return x + y
	}
	
	func testFunction1() {
		let suc = Function1(function1)
		
		XCTAssertTrue(suc.apply(0) == 1, "")
		XCTAssertTrue(suc.apply(suc.apply(0)) == 2, "")
		XCTAssertTrue(suc.apply(suc.apply(suc.apply(0))) == 3, "")
		XCTAssertTrue(suc.apply(suc.apply(suc.apply(suc.apply(0)))) == 4, "")
	}
	
	func testFunction2() {
		let plus = Function2(function2)
		
		XCTAssertTrue(plus.apply(0, y: 0) == 0, "")
		XCTAssertTrue(plus.apply(2, y: 2) == 4, "")
		XCTAssertTrue(plus.apply(2, y: 3) == 5, "")
		XCTAssertTrue(plus.apply(4000, y: 6000) == 10000, "")

	}
}
