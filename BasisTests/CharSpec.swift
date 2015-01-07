//
//  CharSpec.swift
//  Basis
//
//  Created by Robert Widmann on 1/6/15.
//  Copyright (c) 2015 Robert Widmann. All rights reserved.
//

import Basis
import XCTest

class CharSpec : XCTestCase {
	func testIsControl() {
		let x = iterate({ UnicodeScalar($0.value + 1) })(UnicodeScalar(0))
		/// |U+0000—U+001F| == 32
		XCTAssertTrue(takeWhile({ $0.isControl() })(x).count == 32)

		let y = iterate({ x in Character(UnicodeScalar(x.unicodeValue() + 1)) })(Character("\0"))
		/// |U+0000—U+001F| == 32
		XCTAssertTrue(takeWhile({ $0.isControl() })(y).count == 32)
	}

	func testIsSpace() {
		let x : [UnicodeScalar] = ["\t", "\n", "\r", "\u{21A1}", "\u{000B}"]
		XCTAssertTrue(all({ $0.isSpace() })(x))
	}

	func testIsDigit() {
		let x : [UnicodeScalar] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
		XCTAssertTrue(all({ $0.isDigit() })(x))

		let y : [UnicodeScalar] = ["a", "b", "c", "\r"]
		XCTAssertFalse(any({ $0.isDigit() })(y))
	}

	func testIsOctalDigit() {
		let x : [UnicodeScalar] = ["1", "2", "3", "4", "5", "6", "7", "0"]
		XCTAssertTrue(all({ $0.isOctalDigit() })(x))

		let y : [UnicodeScalar] = ["a", "b", "c", "\r", "8", "9"]
		XCTAssertFalse(any({ $0.isOctalDigit() })(y))
	}

	func testIsHexadecimalDigit() {
		let x : [UnicodeScalar] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f"]
		XCTAssertTrue(all({ $0.isHexadecimalDigit() })(x))
		XCTAssertTrue(all({ $0.isHexadecimalDigit() })(x.map({ $0.toUpper() })))

		let y : [UnicodeScalar] = ["g", "h", "i", "\r"]
		XCTAssertFalse(any({ $0.isHexadecimalDigit() })(y))
	}

	func testToUpper() {
		let low = "abcdefghijklmnopqrstuvwxyz".unpack().map({ UnicodeScalar($0.unicodeValue()) })
		let upp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".unpack().map({ UnicodeScalar($0.unicodeValue()) })

		XCTAssertTrue(low.map({ $0.toUpper() }) == upp)
		XCTAssertTrue(upp.map({ $0.toLower() }) == low)
	}
}

