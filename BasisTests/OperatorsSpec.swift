//
//  OperatorsSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
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

	func testOn() {
		let y = 32.0

		XCTAssertTrue(on(+)(f: { s in pow(s, 2.0) })(4.0)(4.0) == y, "")
	}

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
	
	func testChoose() {
		let x : Maybe<Int> = Maybe.just(10)
		let y : Maybe<Int> = Maybe.nothing()

		XCTAssertTrue((x <|> y) === x, "")
	}

	func testBind() {
		let x : Maybe<Int> = Maybe.just(10)

		XCTAssertTrue(fromJust(x >>- { v in Maybe.just(v) }) == fromJust(x), "")
	}

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

