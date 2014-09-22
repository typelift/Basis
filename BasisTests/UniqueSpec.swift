//
//  UniqueSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

#if os(OSX)
import Basis
#else
import MobileBasis
#endif
import XCTest


class UniqueSpec : XCTestCase {
	func testUniqueness() {
		var u1 : Unique!
		var u2 : Unique!
		var u3 : Unique!
		var u4 : Unique!
		var u5 : Unique!

		u1 <- newUnique()
		u2 <- newUnique()
		u3 <- newUnique()
		u4 <- newUnique()
		u5 <- newUnique()

		let a = [u1, u2, u3, u4, u5]
		let s = subsequences(a).filter({ $0.count == 2 }).map({ head($0) ∏ (head • tail)($0) })

		XCTAssertTrue(and(zip(a)(l2: a).map(==)), "")
		XCTAssertTrue(!and(s.map({ $0! == $1! })), "")
	}
}

