//
//  TupleSpec.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift_Extras
import XCTest

class TupleSpec : XCTestCase {
	func testTuples() {
		let t = (10, "String")
		
		XCTAssertTrue(fst(t) == 10, "")
		XCTAssertTrue(snd(t) == "String", "")
	}
	
	func testCurry() {
		XCTAssertTrue(curry(+)(5)(5) == 5 + 5, "")
	}
	
	func testUnCurry() {
		XCTAssertTrue(uncurry(const)(10, 20) == 10, "")
	}
	
	func testSwap() {
		let t = ("String", 10)
		
		XCTAssertTrue(fst(t) == (snd • swap)(t), "")
		XCTAssertTrue(snd(t) == (fst • swap)(t), "")
	}
}
