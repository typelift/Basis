//
//  ZipSpec.swift
//  Basis
//
//  Created by Robert Widmann on 10/30/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Basis
import XCTest


class ZipSpec : XCTestCase {
	func testUnzip() {
		let l = [(1,3), (2,4), (3,5), (4,6)]
		let r = ([1,2,3, 4] , [3, 4, 5, 6])
		
		XCTAssertTrue(unzip(l).0 == r.0, "")
		XCTAssertTrue(unzip(l).1 == r.1, "")
	}
	
	func testUnzip3() {
		let l = [(1,4,7), (2,5,8), (3,6,9)]
		let r = ([1,2,3] , [4,5,6] , [7,8,9])
		
		XCTAssertTrue(unzip3(l).0 == r.0, "")
		XCTAssertTrue(unzip3(l).1 == r.1, "")
		XCTAssertTrue(unzip3(l).2 == r.2, "")
	}
}


