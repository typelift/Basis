//
//  MemberSpec.swift
//  Basis
//
//  Created by Robert Widmann on 11/28/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Basis
import XCTest

class MemberSpec : XCTestCase {
	func testDismember() {
		let t = [1, 2, 3, 4]
		
		XCTAssert(dismember(Array.reverse)(t) == t.reverse(), "")
	}
}
