//
//  TrampolineSpec.swift
//  Basis
//
//  Created by Robert Widmann on 12/21/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Basis
import XCTest

class TrampolineSpec : XCTestCase {
//	func fac(x : Double, _ acc : Double = 1.0) -> Double {
//		if x == 1.0 {
//			return acc
//		}
//		return fac(x - 1, acc * x)
//	}
	
	/// Evaluates to a ludicrous value but without smashing the stack.
	func noSmashFac(_ x : Double, _ acc : Double = 1.0) -> Trampoline<Double> {
		if x <= 1 {
			return now(acc)
		}
		return later { self.noSmashFac(x - 1, acc * x) }
	}
	
	func noSmashAckermann(_ m : Int, _ n : Int) -> Trampoline<Int> {
		if m == 0 {
			return now(n + 1)
		}
		if n == 0 {
			return later { self.noSmashAckermann(m - 1, 1) }
		}
		return later { self.noSmashAckermann(m - 1, later { self.noSmashAckermann(m, n - 1) }.run()) }
	}
	
	func testFactorial() {
		let x = noSmashFac(50000).run()
		XCTAssertTrue(x == Swift.Double.infinity, "")
		/// We can't push 50,000 frames without getting totes murdered by the OS.
//		let y = fac(50000)
//		XCTAssertTrue(y == Swift.Double.infinity, "")
	}
	
	
	func testAckermann() {
		XCTAssertTrue(noSmashAckermann(0, 0).run() == 1, "")
		XCTAssertTrue(noSmashAckermann(3, 4).run() == 125, "")
		/// Try not to run this.
//		XCTAssertTrue(noSmashAckermann(5, 1).run() == 65533, "")
	}
}
