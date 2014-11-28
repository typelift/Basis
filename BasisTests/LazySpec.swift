//
//  LazySpec.swift
//  Basis
//
//  Created by Robert Widmann on 11/6/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Foundation
import Basis
import XCTest

class LazySpec : XCTestCase {
	func testLazyValue() {
		var box : Int = 0
		let lazy = delay({ box = 10 })
		XCTAssertTrue(box == 0, "")
		force(lazy)
		XCTAssertTrue(box == 10, "")
	}
}

