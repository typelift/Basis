//
//  ListSpec.swift
//  Basis
//
//  Created by Robert Widmann on 12/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//


import Foundation
import Basis
import XCTest

class ListSpec : XCTestCase {
	func testDestructure() {
		let l = [1, 2, 3, 4]
		
		switch destruct(l) {
			case .Empty:
				assert(false, "")
			case .Cons(let hd, let tl):
				XCTAssertTrue(hd == 1, "")
				XCTAssertTrue(tl == [2, 3, 4], "")
		}
	}
	
	func testSort() {
		let x = [1, 4, 3, 6, 7, 0, 2]
		let y = [0, 1, 2, 3, 4, 6, 7]
		
		XCTAssertTrue(sort(x) == y, "")
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
	
	func testStripPrefix() {
		let s = "Get thee to a nunnery!"
		
		let t = stripPrefix(unpack("Get thee to a "))(unpack(s))
		XCTAssertTrue(Maybe.fmap(pack)(t) == Maybe<String>.just("nunnery!"), "")
	}
	
	func testStripSuffix() {
		let s = "Get thee to a nunnery!"
		
		let t = stripSuffix(unpack(" nunnery!"))(unpack(s))
		XCTAssertTrue(Maybe.fmap(pack)(t) == Maybe<String>.just("Get thee to a"), "")
	}
}

