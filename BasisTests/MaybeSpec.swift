//
//  MaybeSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest


class MaybeSpec : XCTestCase {
	func testMaybe() {
		let def = 10
		let f = { $0 + 10 }

		let m1 = Optional.Some(10)
		let m2 : Int? = Optional.None

		XCTAssertTrue(maybe(def)(f: f)(m: m1) == 20, "")
		XCTAssertTrue(maybe(def)(f: f)(m: m2) == 10, "")
	}

	func testGestalt() {
		let m1 = Optional.Some(10)
		let m2 : Int? = Optional.None

		XCTAssertTrue(isSome(m1), "")
		XCTAssertTrue(isNone(m2), "")
	}

	func testFrom() {
		let def = 10
		let m1 = Optional.Some(100)
		let m2 : Int? = Optional.None

		XCTAssertTrue(fromSome(m1) == 100, "")

		XCTAssertTrue(fromOptional(def)(m: m1) == 100, "")
		XCTAssertTrue(fromOptional(def)(m: m2) == 10, "")
	}

	func testOptionalToList() {
		let m1 = Optional.Some(100)
		let m2 : Int? = Optional.None

		XCTAssertTrue(optionalToList(m1) == [100], "")
		XCTAssertTrue(optionalToList(m2) == [], "")
	}

	func testListToOptional() {
		let l1 = []
		let l2 = [100]

		XCTAssertTrue(listToOptional(l1) == nil, "")
		XCTAssertTrue(listToOptional(l2) == Optional.Some(100), "")
	}

	func testCatOptionals() {
		let x = Optional.Some(5)
		let l = [ x, nil, x, nil, x, nil, x ]

		XCTAssertTrue(foldr1(+)(catOptionals(l)) == 20, "")
	}

	func testMapOptionals() {
		let l = [ [5], [], [5], [], [5], [] ]

		XCTAssertTrue(foldr1(+)(mapOptional(listToOptional)(l: l)) == 15, "")
	}
}

