//
//  OperatorsSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Basis
import XCTest


class OperatorsSpec : XCTestCase {
	func testAfter() {
		let s = ""
		let f = { $0 + "World!" }
		let g = { $0 + "Hello, " }

		XCTAssertTrue((f • g)(s) == "Hello, World!", "")
	}

	func testPipeBackwards() {
		let f = { $0 + 5 }
		let g = { $0 + 10 }
		let h = { $0 + 20 }
		let x = 5

		XCTAssertTrue((f <| g <| h(x)) == f(g(h(x))) , "")
	}

	func testPipeForwards() {
		let f = { $0 + 5 }
		let g = { $0 + 10 }
		let h = { $0 + 20 }
		let x = 5

		XCTAssertTrue((h(x) |> g |> f) == f(g(h(x))) , "")
	}

	func testPairFormation() {
		let x = "String"
		let y = 20

		XCTAssertTrue(fst(x ∏ y) == fst((x, y)), "")
		XCTAssertTrue(snd(x ∏ y) == snd((x, y)), "")
	}

// Uncomment to crash Swiftc
//	func testOn() {
//		let x = "String"
//		let y = 20
//
//		XCTAssertTrue(on(+)(f: { pow($0, 2.0) })(4.0)(4.0) == 10.0, "")
//
//	}

	func testRLCompose() {
		let f = ^{ $0 + 5 }
		let g = ^{ $0 + 10 }
		let h = ^{ $0 + 20 }
		let x = 5

		XCTAssertTrue((f <<< g <<< h).apply(x) == f.apply(g.apply(h.apply(x))), "")
	}

	func testLRCompose() {
		let f = ^{ $0 + 5 }
		let g = ^{ $0 + 10 }
		let h = ^{ $0 + 20 }
		let x = 5

		XCTAssertTrue((h >>> g >>> f).apply(x) == f.apply(g.apply(h.apply(x))), "")
	}

//	func testReplace() {
//		let l = [1, 2, 3, 4, 5]
//
//		XCTAssertTrue(and(true <% l), "")
//	}
//
//	func testFmap() {
//		let l = [1, 2, 3, 4, 5]
//		let f = { $0 * 10 }
//
//		XCTAssertTrue(and(zip(f <%> l)(l.map(f)).map(==)), "")
//	}
//
//	func testSequence() {
//		let l1 = [1, 2, 3, 4, 5]
//		let l2 = [6, 7, 8, 9, 10]
//
//		let ar = l1 *> l2
//		XCTAssertTrue(and(zip(l1 <* l2)(concatMap({ replicate(5)(x: $0) })(l: l1)).map(==)), "")
//		XCTAssertTrue(and(zip(l1 *> l2)(l2).map(==)), "")
//	}
//
//	func testChoose() {
//		let x : Int? = Optional.Some(10)
//		let y : Int? = Optional.None
//
//		XCTAssertTrue((x <|> y) == x, "")
//	}
//
//	func testBind() {
//		let x : Int? = Optional.Some(10)
//
//		XCTAssertTrue((x >>- { .Some($0) }) == id(x), "")
//	}

	func testSplit() {
		let f = ^{ $0 + 5 }
		let g = ^{ $0 + " Zone!" }

		XCTAssertTrue(fst((f *** g).apply(5, "Danger")) == 10, "")
		XCTAssertTrue(snd((f *** g).apply(5, "Danger")) == "Danger Zone!", "")
	}

	func testFanout() {
		let f = ^{ $0 + 5 }
		let g = ^{ $0 + 10 }

		XCTAssertTrue(fst((f &&& g).apply(5)) == 10, "")
		XCTAssertTrue(snd((f &&& g).apply(5)) == 15, "")
	}

	func testSplat() {
		let f = ^{ $0 + "!" }
		let g = ^{ $0 + "Bro" }

		let left = Either<String, String>.left("Ruh-Roh")
		let right = Either<String, String>.right("UMad")

		XCTAssertTrue(isLeft((f +++ g).apply(left)), "")
		XCTAssertTrue(isRight((f +++ g).apply(right)), "")
	}

	func testFanin() {
		let f = ^{ $0 + 5 }
		let g = ^{ $0 + 10 }

		let left = Either<Int, Int>.left(10)
		let right = Either<Int, Int>.right(10)

		XCTAssertTrue((f ||| g).apply(left) == 15, "")
		XCTAssertTrue((f ||| g).apply(right) == 20, "")
	}

}

