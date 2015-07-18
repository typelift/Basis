//
//  OptionalSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest


class OptionalSpec : XCTestCase {
	func testOptional() {
		let def = 10
		let f = { $0 + 10 }

		let m1 = Optional.Some(10)
		let m2 : Int? = Optional.None

		XCTAssertTrue(Optional(def)(f: f)(m: m1) == 20, "")
		XCTAssertTrue(Optional(def)(f: f)(m: m2) == 10, "")
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
		let l1 = [Int]()
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
	
	func liftA<A, B>(f : A -> B) -> Optional<A> -> Optional<B> {
		return { a in Optional.pure(f) <*> a }
	}
	
	func liftA2<A, B, C>(f : A -> B -> C) -> Optional<A> -> Optional<B> -> Optional<C> {
		return { a in { b in Optional.pure(f) <*> a <*> b } }
	}
	
	func liftA3<A, B, C, D>(f : A -> B -> C -> D) -> Optional<A> -> Optional<B> -> Optional<C> -> Optional<D> {
		return { a in { b in { c in Optional.pure(f) <*> a <*> b <*> c } } }
	}
	
	func testApplicative() {
		let a = Optional.Some(6)
		let b = Optional<Int>.None
		let c = Optional.Some(5)

		let r = liftA2(curry(+))(a)(b)
		XCTAssertTrue(r == Optional<Int>.None)
		
		let rr = liftA2(curry(+))(a)(c)
		XCTAssertTrue(rr == Optional.Some(11))
		
		let t = liftA3(pack3)(a)(b)(c)
		XCTAssertTrue(t == Optional<(Int, Int, Int)>.None)
	}
}

