//
//  MonoidSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/24/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class MonoidSpec : XCTestCase {
	func testEndoLeftIdentity() {
		XCTAssertTrue((Endo.mempty() <> Endo(id)).appEndo(5) == 5, "")
	}
	
	func testEndoRightIdentity() {
		XCTAssertTrue((Endo(id) <> Endo.mempty()).appEndo(5) == 5, "")
	}
	
	func testEndoMappend() {
		let x = Endo<Int>(id)
		let y = Endo<Int>(id)
		let z = Endo<Int>(id)
		XCTAssertTrue(((x <> y) <> z).appEndo(5) == (x <> (y <> z)).appEndo(5), "")
	}
	
	func testAllLeftIdentity() {
		XCTAssertTrue((All.mempty() <> All(true)).getAll == true, "")
		XCTAssertTrue((All.mempty() <> All(false)).getAll == false, "")
	}
	
	func testAllRightIdentity() {
		XCTAssertTrue((All(false) <> All.mempty()).getAll == false, "")
		XCTAssertTrue((All(true) <> All.mempty()).getAll == true, "")
	}
	
	func testAllMappend() {
		let x = All(true)
		let y = All(false)
		let z = All(true)
		XCTAssertTrue(((x <> y) <> z).getAll == (x <> (y <> z)).getAll, "")
	}
	
	func testAnyLeftIdentity() {
		XCTAssertTrue((Any.mempty() <> Any(true)).getAny == true, "")
		XCTAssertTrue((Any.mempty() <> Any(false)).getAny == false, "")
	}
	
	func testAnyRightIdentity() {
		XCTAssertTrue((Any(false) <> Any.mempty()).getAny == false, "")
		XCTAssertTrue((Any(true) <> Any.mempty()).getAny == true, "")
	}
	
	func testAnyMappend() {
		let x = Any(true)
		let y = Any(false)
		let z = Any(true)
		XCTAssertTrue(((x <> y) <> z).getAny == (x <> (y <> z)).getAny, "")
	}
	
	func testSumLeftIdentity() {
		XCTAssertTrue((Sum.mempty() <> Sum(5)).getSum == 5, "")
	}
	
	func testSumRightIdentity() {
		XCTAssertTrue((Sum(5) <> Sum.mempty()).getSum == 5, "")
	}
	
	func testSumMappend() {
		let x = Sum(5)
		let y = Sum(10)
		let z = Sum(20)
		XCTAssertTrue(((x <> y) <> z).getSum == (x <> (y <> z)).getSum, "")
	}	
	
	func testProductLeftIdentity() {
		XCTAssertTrue((Product.mempty() <> Product(5)).getProduct == 5, "")
	}
	
	func testProductRightIdentity() {
		XCTAssertTrue((Product(5) <> Product.mempty()).getProduct == 5, "")
	}
	
	func testProductMappend() {
		let x = Product(5)
		let y = Product(10)
		let z = Product(20)
		XCTAssertTrue(((x <> y) <> z).getProduct == (x <> (y <> z)).getProduct, "")
	}
	
	func testFirstLeftIdentity() {
		XCTAssertTrue((First.mempty() <> First(Maybe.just(5))).getFirst == Maybe<Int>.just(5), "")
	}
	
	func testFirstRightIdentity() {
		XCTAssertTrue((First(Maybe.just(5)) <> First.mempty()).getFirst == Maybe.just(5), "")
	}
	
	func testFirstMappend() {
		let x = First(Maybe.just(5))
		let y = First(Maybe.just(10))
		let z = First(Maybe.just(15))
		XCTAssertTrue(((x <> y) <> z).getFirst == (x <> (y <> z)).getFirst, "")
	}
	
	func testLastLeftIdentity() {
		XCTAssertTrue((Last.mempty() <> Last(Maybe.just(5))).getLast == Maybe<Int>.just(5), "")
	}
	
	func testLastRightIdentity() {
		XCTAssertTrue((Last(Maybe.just(5)) <> Last.mempty()).getLast == Maybe.just(5), "")
	}
	
	func testLastMappend() {
		let x = Last(Maybe.just(5))
		let y = Last(Maybe.just(10))
		let z = Last(Maybe.just(15))
		XCTAssertTrue(((x <> y) <> z).getLast == (x <> (y <> z)).getLast, "")
	}
	
	func testMinLeftIdentity() {
		XCTAssertTrue((Min.mempty() <> Min(5)).getMin == 5, "")
	}
	
	func testMinRightIdentity() {
		XCTAssertTrue((Min(5) <> Min.mempty()).getMin == 5, "")
	}
	
	func testMinMappend() {
		let x = Min(5)
		let y = Min(10)
		let z = Min(15)
		XCTAssertTrue(((x <> y) <> z).getMin == (x <> (y <> z)).getMin, "")
	}
	
	func testMaxLeftIdentity() {
		XCTAssertTrue((Max.mempty() <> Max(5)).getMax == 5, "")
	}
	
	func testMaxRightIdentity() {
		XCTAssertTrue((Max(5) <> Max.mempty()).getMax == 5, "")
	}
	
	func testMaxMappend() {
		let x = Max(5)
		let y = Max(10)
		let z = Max(15)
		XCTAssertTrue(((x <> y) <> z).getMax == (x <> (y <> z)).getMax, "")
	}	
}

