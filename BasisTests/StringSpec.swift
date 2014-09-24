//
//  StringSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

#if os(OSX)
import Basis
#else
import MobileBasis
#endif
import XCTest


class StringSpec : XCTestCase {
	func testDestruct() {
		let str = "abcdefghijklmnopqrstuvwxyz"
		
		XCTAssertTrue(all({ $0 == 1 })(l: map({ $0.count })(l: group(str.unpack()))), "")
	}
}

