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
		XCTAssertTrue((Dual<All>.mempty() <> Dual<All>(All(false))).getDual == All(false), "")
	}
	
	func testDualRightIdentity() {
		XCTAssertTrue((Dual(All(false)) <> Dual<All>.mempty()).getDual == All(false), "")
	}
	
	func testDualMappend() {
		let x = Dual<All>(All(true))
		let y = Dual<All>(All(false))
		let z = Dual<All>(All(true))
		XCTAssertTrue(((x <> y) <> z).getDual == (x <> (y <> z)).getDual, "")
	}
	
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
		XCTAssertTrue((All.mempty() <> All(true)) == All(true), "")
		XCTAssertTrue((All.mempty() <> All(false)) == All(false), "")
	}
	
	func testAllRightIdentity() {
		XCTAssertTrue((All(true) <> All.mempty()) == All(true), "")
		XCTAssertTrue((All(false) <> All.mempty()) == All(false), "")
	}
	
	func testAllMappend() {
		let x = All(true)
		let y = All(false)
		let z = All(true)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testExistsLeftIdentity() {
		XCTAssertTrue((Exists.mempty() <> Exists(true)) == Exists(true), "")
		XCTAssertTrue((Exists.mempty() <> Exists(false)) == Exists(false), "")
	}
	
	func testExistsRightIdentity() {
		XCTAssertTrue((Exists(false) <> Exists.mempty()) == Exists(false), "")
		XCTAssertTrue((Exists(true) <> Exists.mempty()) == Exists(true), "")
	}
	
	func testExistsMappend() {
		let x = Exists(true)
		let y = Exists(false)
		let z = Exists(true)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testSumLeftIdentity() {
		XCTAssertTrue((Sum.mempty() <> Sum(5)) == Sum(5), "")
	}
	
	func testSumRightIdentity() {
		XCTAssertTrue((Sum(5) <> Sum.mempty()) == Sum(5), "")
	}
	
	func testSumMappend() {
		let x = Sum(5)
		let y = Sum(10)
		let z = Sum(20)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}	
	
	func testProductLeftIdentity() {
		XCTAssertTrue((Product.mempty() <> Product(5)) == Product(5), "")
	}
	
	func testProductRightIdentity() {
		XCTAssertTrue((Product(5) <> Product.mempty()) == Product(5), "")
	}
	
	func testProductMappend() {
		let x = Product(5)
		let y = Product(10)
		let z = Product(20)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testFirstLeftIdentity() {
		XCTAssertTrue((First.mempty() <> First(Optional.Some(5))) == First(Optional.Some(5)), "")
	}
	
	func testFirstRightIdentity() {
		XCTAssertTrue((First(Optional.some(5)) <> First.mempty()) == First(Optional.Some(5)), "")
	}
	
	func testFirstMappend() {
		let x = First(Optional.some(5))
		let y = First(Optional.some(10))
		let z = First(Optional.some(15))
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testLastLeftIdentity() {
		XCTAssertTrue((Last.mempty() <> Last(Optional.Some(5))) == Last(Optional.Some(5)), "")
	}
	
	func testLastRightIdentity() {
		XCTAssertTrue((Last(Optional.some(5)) <> Last.mempty()) == Last(Optional.Some(5)), "")
	}
	
	func testLastMappend() {
		let x = Last(Optional.some(5))
		let y = Last(Optional.some(10))
		let z = Last(Optional.some(15))
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testMinLeftIdentity() {
		XCTAssertTrue((Min.mempty() <> Min(5)) == Min(5), "")
	}
	
	func testMinRightIdentity() {
		XCTAssertTrue((Min(5) <> Min.mempty()) == Min(5), "")
	}
	
	func testMinMappend() {
		let x = Min(5)
		let y = Min(10)
		let z = Min(15)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
	
	func testMaxLeftIdentity() {
		XCTAssertTrue((Max.mempty() <> Max(5)) == Max(5), "")
	}
	
	func testMaxRightIdentity() {
		XCTAssertTrue((Max(5) <> Max.mempty()) == Max(5), "")
	}
	
	func testMaxMappend() {
		let x = Max(5)
		let y = Max(10)
		let z = Max(15)
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}

	func testStringLeftIdentity() {
		XCTAssertTrue((String.mempty() <> "String") == "String", "")
	}

	func testStringRightIdentity() {
		XCTAssertTrue(("String" <> String.mempty()) == "String", "")
	}

	func testStringMappend() {
		let x = "Abra"
		let y = "Cadabra"
		let z = "Alacazam"
		XCTAssertTrue(((x <> y) <> z) == (x <> (y <> z)), "")
	}
}

