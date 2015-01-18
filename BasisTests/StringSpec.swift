//
//  StringSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest


class StringSpec : XCTestCase {
	func testmatch() {
		let str = "abcdefghijklmnopqrstuvwxyz"
		
		XCTAssertTrue(all({ $0 == 1 })(map({ $0.count })(group(str.unpack()))), "")
	}
}

