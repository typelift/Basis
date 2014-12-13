//
//  ListSpec.swift
//  Basis
//
//  Created by Robert Widmann on 12/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//


import Foundation
import Basis
import XCTest

class ListSpec : XCTestCase {
	func testSort() {
		let x = [1, 4, 3, 6, 7, 0, 2]
		let y = [0, 1, 2, 3, 4, 6, 7]
		
		XCTAssertTrue(sort(x) == y, "")
	}
}

