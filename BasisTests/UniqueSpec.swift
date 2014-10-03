//
//  UniqueSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Basis
import XCTest


class UniqueSpec : XCTestCase {
	func testUniqueness() {
		let u1 = !newUnique()
		let u2 = !newUnique()
		let u3 = !newUnique()
		let u4 = !newUnique()
		let u5 = !newUnique()

		let a = [u1, u2, u3, u4, u5]
		let s = subsequences(a).filter({ $0.count == 2 }).map({ head($0) ∏ (head • tail)($0) })

		XCTAssertTrue(and(zip(a)(a).map(==)), "")
		XCTAssertTrue(!and(s.map({ $0 == $1 })), "")
	}
}

