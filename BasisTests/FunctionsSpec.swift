//
//  FunctionsSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest


class FunctionsSpec : XCTestCase {
	func testId() {
		XCTAssertTrue(id(10) == 10, "")
	}
	
	func testConst() {
		XCTAssertTrue(const(10)(20) == 10, "")
	}
	
	func testComposition() {
		let f = { (x : Int) -> Int in
			return x + 10
		}
		
		let g = { (x : Int) -> Int in
			return x - 20
		}
		
		XCTAssertTrue((f • g)(20) == 10, "")
	}
	
	func testBackwardAp() {
		let f = { (x : Int) -> Int in
			return x + 10
		}
		
		let g = { (x : Int) -> Int in
			return x - 20
		}
		
		let h = { (x : Int) -> Int in
			return x + 100
		}
		
		XCTAssertTrue((f <| g <| h(20)) == 110, "")
	}
	
	func testForwardAp() {
		let f = { (x : Int) -> Int in
			return x + 10
		}
		
		let g = { (x : Int) -> Int in
			return x - 20
		}
		
		let h = { (x : Int) -> Int in
			return x + 100
		}
		
		XCTAssertTrue((h(20) |> g |> f) == 110, "")
	}
	
	func testMaybe() {
		let def = -1
		let x = maybe(def)(f: { $0 + 1 })(m : .Some(5))
		let y = maybe(def)(f: { $0 + 1 })(m : .None)
		
		XCTAssertTrue(x == 6, "")
		XCTAssertTrue(y == def, "")
	}
	
	func testFlip() {
		let arr = [0, 1, 2, 3, 4, 5]
		
		XCTAssertTrue(flip(const)(10)(20) == 20, "")
	}
	
	func testUntil() {
		let x = 1
		
		XCTAssertTrue(until({ $0 == 5 })({ $0 + 1 })(x) == 5, "")
	}
	
	func testOn() {
		var arr : [(Int, String)] = [(2, "Second"), (1, "First"), (5, "Fifth"), (3, "Third"), (4, "Fourth")]
		var sarr : [(Int, String)] = [(1, "First"), (2, "Second"), (3, "Third"), (4, "Fourth"), (5, "Fifth")]

		var srt = sortBy((>) |*| fst)(arr)
		
		XCTAssertTrue(and(zip(srt.map(fst))(sarr.map(fst)).map(==)), "")
		XCTAssertTrue(and(zip(srt.map(snd))(sarr.map(snd)).map(==)), "")
	}
	
	func testFixpoint() {
		let f : (Int -> Int) -> Int -> Int = { fact in
			return { x in
				if x == 0 {
					return 1
				}
				return x * fact(x - 1)
			}
		}
		
		XCTAssertTrue(fix(f)(5) == 120, "")
	}
}
