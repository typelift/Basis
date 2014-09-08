//
//  FunctionsSpec.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift_Extras
import XCTest

class FunctionsSpec : XCTestCase {
	func testId() {
		XCTAssertTrue(id(10) == 10, "")
	}
	
	func testTuples() {
		let t = (10, "String")
		
		XCTAssertTrue(fst(t) == 10, "")
		XCTAssertTrue(snd(t) == "String", "")
	}
	
	func testMaybe() {
		let def = -1
		let x = maybe(def)(f: { $0 + 1 })(m : .Some(5))
		let y = maybe(def)(f: { $0 + 1 })(m : .None)
		
		XCTAssertTrue(x == 6, "")
		XCTAssertTrue(y == def, "")
	}
}
