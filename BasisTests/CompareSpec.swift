//
//  CompareSpec.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 9/26/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Basis
import XCTest

class CompareSpec : XCTestCase {
	func testGroupBy() {
		let x = [1, 1, 2, 3, 3, 4, 4, 4, 5, 6, 6]
		let y = [[1, 1], [2], [3, 3], [4, 4, 4], [5], [6, 6]]

		XCTAssertTrue(and(zip(groupBy(==)(x).map({ $0.count }))(y.map({ $0.count })).map(==)), "")
		XCTAssertTrue(and(zip(groupBy(==)(x).map(head))(y.map(head)).map(==)), "")
		XCTAssertTrue(and(groupBy(==)(x).map({ l in all({ head(l) == $0 })(l) })), "")
	}

	func testNubBy() {
		let x = [1, 1, 2, 3, 3, 4, 4, 4, 5, 6, 6]
		let y = [1, 2, 3, 4, 5, 6]

		XCTAssertTrue(and(zip(nubBy(==)(x))(y).map(==)), "")
	}
}
