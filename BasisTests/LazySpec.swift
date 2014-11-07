//
//  LazySpec.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 11/6/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
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

