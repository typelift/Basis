//
//  ListSpec.swift
//  Basis
//
//  Created by Robert Widmann on 12/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//


import Foundation
import Basis
import XCTest

class ListSpec : XCTestCase {
	func testDestructure() {
		let l = [1, 2, 3, 4]
		
		switch match(l) {
			case .nil:
				fatalError("")
			case .cons(let hd, let tl):
				XCTAssertTrue(hd == 1, "")
				XCTAssertTrue(tl == [2, 3, 4], "")
		}
	}
	
	func testSort() {
		let x = [1, 4, 3, 6, 7, 0, 2]
		let y = [0, 1, 2, 3, 4, 6, 7]
		
		XCTAssertTrue(sort(x) == y, "")
	}
	
	func testReplicate() {
		let arr = replicate(5)("Hello")
		
		XCTAssertTrue(arr[0] == "Hello", "")
		XCTAssertTrue(arr[1] == "Hello", "")
		XCTAssertTrue(arr[2] == "Hello", "")
		XCTAssertTrue(arr[3] == "Hello", "")
		XCTAssertTrue(arr[4] == "Hello", "")
	}
	
	func testIsPrefixOf() {
		let x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		
		XCTAssertTrue(isPrefixOf([1, 2, 3, 4])(x), "")
		XCTAssertFalse(isPrefixOf([1, 2, 4])(x), "")
	}
	
	func testIsSuffixOf() {
		let x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		
		XCTAssertTrue(isSuffixOf([7, 8, 9, 10])(x), "")
		XCTAssertFalse(isSuffixOf([8, 10])(x), "")
	}
	
	func testIsInfixOf() {
		let x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		
		XCTAssertTrue(isInfixOf([4, 5, 6])(x), "")
		XCTAssertFalse(isInfixOf([4, 6])(x), "")
	}
}

