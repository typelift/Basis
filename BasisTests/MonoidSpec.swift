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
	func testDualLeftIdentity() {
		XCTAssertTrue((Dual<All>.mzero <> Dual<All>(All(false))).getDual == All(false), "")
	}
	
	func testDualRightIdentity() {
		XCTAssertTrue((Dual(All(false)) <> Dual<All>.mzero).getDual == All(false), "")
	}
	
	func testDualMappend() {
		let x = Dual<All>(All(true))
		let y = Dual<All>(All(false))
		let z = Dual<All>(All(true))
		XCTAssertTrue(((x <> y) <> z).getDual == (x <> (y <> z)).getDual, "")
	}
	
	func testEndoLeftIdentity() {
		XCTAssertTrue((Endo.mzero <> Endo(id)).appEndo(5) == 5, "")
	}
	
	func testEndoRightIdentity() {
		XCTAssertTrue((Endo(id) <> Endo.mzero).appEndo(5) == 5, "")
	}
	
	func testEndoMappend() {
		let x = Endo<Int>(id)
		let y = Endo<Int>(id)
		let z = Endo<Int>(id)
		XCTAssertTrue(((x <> y) <> z).appEndo(5) == (x <> (y <> z)).appEndo(5), "")
	}
	
	func testAllLeftIdentity() {
		XCTAssertTrue((All.mzero <> All(true)) == All(true), "")
		XCTAssertTrue((All.mzero <> All(false)) == All(false), "")
	}
	
	func testAllRightIdentity() {
		XCTAssertTrue((All(true) <> All.mzero) == All(true), "")
		XCTAssertTrue((All(false) <> All.mzero) == All(false), "")
	}
	
	func testAllMappend() {
		let x = All(true)
		let y = All(false)
		let z = All(true)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testExistsLeftIdentity() {
		XCTAssertTrue((Exists.mzero <> Exists(true)) == Exists(true), "")
		XCTAssertTrue((Exists.mzero <> Exists(false)) == Exists(false), "")
	}
	
	func testExistsRightIdentity() {
		XCTAssertTrue((Exists(false) <> Exists.mzero) == Exists(false), "")
		XCTAssertTrue((Exists(true) <> Exists.mzero) == Exists(true), "")
	}
	
	func testExistsMappend() {
		let x = Exists(true)
		let y = Exists(false)
		let z = Exists(true)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testSumLeftIdentity() {
		XCTAssertTrue((Sum.mzero <> Sum(5)) == Sum(5), "")
	}
	
	func testSumRightIdentity() {
		XCTAssertTrue((Sum(5) <> Sum.mzero) == Sum(5), "")
	}
	
	func testSumMappend() {
		let x = Sum(5)
		let y = Sum(10)
		let z = Sum(20)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}	
	
	func testProductLeftIdentity() {
		XCTAssertTrue((Product.mzero <> Product(5)) == Product(5), "")
	}
	
	func testProductRightIdentity() {
		XCTAssertTrue((Product(5) <> Product.mzero) == Product(5), "")
	}
	
	func testProductMappend() {
		let x = Product(5)
		let y = Product(10)
		let z = Product(20)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testFirstLeftIdentity() {
		XCTAssertTrue((First.mzero <> First(Optional.some(5))) == First(Optional.some(5)), "")
	}
	
	func testFirstRightIdentity() {
		XCTAssertTrue((First(Optional.some(5)) <> First.mzero) == First(Optional.some(5)), "")
	}
	
	func testFirstMappend() {
		let x = First(Optional.some(5))
		let y = First(Optional.some(10))
		let z = First(Optional.some(15))
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testLastLeftIdentity() {
		XCTAssertTrue((Last.mzero <> Last(Optional.some(5))) == Last(Optional.some(5)), "")
	}
	
	func testLastRightIdentity() {
		XCTAssertTrue((Last(Optional.some(5)) <> Last.mzero) == Last(Optional.some(5)), "")
	}
	
	func testLastMappend() {
		let x = Last(Optional.some(5))
		let y = Last(Optional.some(10))
		let z = Last(Optional.some(15))
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}

	func testMinMappend() {
		let x = Min(5)
		let y = Min(10)
		let z = Min(15)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}

	func testMaxMappend() {
		let x = Max(5)
		let y = Max(10)
		let z = Max(15)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
}

