//
//  CompareSpec.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 9/26/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
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

	func testArrayComparisons() {
		let xs = [1, 2, 3, 4]
		let ys = [1, 2, 3]
		let zs = [3, 4, 5]

		XCTAssertTrue(xs >= xs, "")
		XCTAssertTrue(ys >= ys, "")
		XCTAssertTrue(zs >= zs, "")

		XCTAssertTrue(xs <= xs, "")
		XCTAssertTrue(ys <= ys, "")
		XCTAssertTrue(zs <= zs, "")

		XCTAssertTrue(xs >= ys, "")
		XCTAssertTrue(zs >= ys, "")
		XCTAssertTrue(xs <= zs, "")

		XCTAssertTrue(ys <= xs, "")
		XCTAssertTrue(ys <= zs, "")
		XCTAssertTrue(zs >= xs, "")

		XCTAssertTrue(xs > ys, "")
		XCTAssertTrue(zs > ys, "")
		XCTAssertTrue(xs < zs, "")

		XCTAssertTrue(ys < xs, "")
		XCTAssertTrue(ys < zs, "")
		XCTAssertTrue(zs > xs, "")

		let l : [Int] = []
		let r : [Int] = []
		XCTAssertTrue(l >= r, "")
		XCTAssertTrue(l <= r, "")
		XCTAssertFalse(l < r, "")
		XCTAssertFalse(l > r, "")
	}
}
