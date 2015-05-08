//
//  MaybeSpec.swift
//  Basis
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest


class MaybeSpec : XCTestCase {
	func testMaybe() {
		let def = 10
		let f = { $0 + 10 }

		let m1 = Optional.Some(10)
		let m2 : Int? = Optional.None

		XCTAssertTrue(maybe(def)(f: f)(m: m1) == 20, "")
		XCTAssertTrue(maybe(def)(f: f)(m: m2) == 10, "")
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
	
	func liftA<A, B>(f : A -> B) -> Maybe<A> -> Maybe<B> {
		return { a in Maybe.pure(f) <*> a }
	}
	
	func liftA2<A, B, C>(f : A -> B -> C) -> Maybe<A> -> Maybe<B> -> Maybe<C> {
		return { a in { b in Maybe.pure(f) <*> a <*> b } }
	}
	
	func liftA3<A, B, C, D>(f : A -> B -> C -> D) -> Maybe<A> -> Maybe<B> -> Maybe<C> -> Maybe<D> {
		return { a in { b in { c in Maybe.pure(f) <*> a <*> b <*> c } } }
	}
	
	func testApplicative() {
		let a = Maybe.just(6)
		let b = Maybe<Int>.nothing()
		let c = Maybe.just(5)

		let r = liftA2(curry(+))(a)(b)
		XCTAssertTrue(r == Maybe<Int>.nothing())
		
		let rr = liftA2(curry(+))(a)(c)
		XCTAssertTrue(rr == Maybe.just(11))
		
		let t = liftA3(pack3)(a)(b)(c)
		XCTAssertTrue(t == Maybe<(Int, Int, Int)>.nothing())
	}
}

