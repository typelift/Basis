//
//  FoldsSpec.swift
//  Basis
//
//  Created by Robert Widmann on 12/22/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class FoldsSpec : XCTestCase {
	func testFoldl() {
		let x = [1, 2, 3, 4, 5]
		
		XCTAssertTrue(foldl(+)(0)(x) == 15, "")
		XCTAssertTrue(foldl(curry(+))(0)(x) == 15, "")
	}
	
	func testFoldl1() {
		let x = [0, 1, 2, 3, 4, 5]
		
		XCTAssertTrue(foldl1(+)(x) == 15, "")
		XCTAssertTrue(foldl(+)(0)(x) == foldl1(+)(x), "")
		
		XCTAssertTrue(foldl1(curry(+))(x) == 15, "")
		XCTAssertTrue(foldl(curry(+))(0)(x) == foldl1(+)(x), "")
	}
	
	func testFoldr() {
		let x = [1, 2, 3, 4, 5]
		
		XCTAssertTrue(foldr(+)(0)(x) == 15, "")
		XCTAssertTrue(foldr(curry(+))(0)(x) == 15, "")
	}
	
	func testFoldr1() {
		let x = [0, 1, 2, 3, 4, 5]
		
		XCTAssertTrue(foldr1(+)(x) == 15, "")
		XCTAssertTrue(foldr(+)(0)(x) == foldr1(+)(x), "")
		
		XCTAssertTrue(foldr1(curry(+))(x) == 15, "")
		XCTAssertTrue(foldr(curry(+))(0)(x) == foldr1(+)(x), "")
	}
	
	func testUnfoldr() {
		let x = [0, 1, 2, 3, 4, 5]
		
		XCTAssertTrue(unfoldr(const(Optional<(Int, Int)>.none))(0) == [], "")
		XCTAssertTrue(unfoldr({ if $0 > 5 { return .none }; return .some(($0, $0 + 1)) })(0) == x, "")
	}
}

