//
//  MemberSpec.swift
//  Basis
//
//  Created by Robert Widmann on 11/28/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class MemberSpec : XCTestCase {
	func testDismember() {
		let t = [1, 2, 3, 4]
		
		XCTAssert(dismember(Array.reverse)(t) == t.reverse(), "")
		XCTAssert(dismember(Array.filter)(t)({ x in x == 3 }) == t.filter({x in x == 3}), "")
		XCTAssert(dismember(Array.reduce)(t)(0)(+) == t.reduce(0, combine: +), "")
	}
}
