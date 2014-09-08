//
//  OperatorsSpec.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation
import Swift_Extras
import XCTest

class OperatorsSpec : XCTestCase {
	func testAfter() {
		var s = ""
		
		let f = {
			$0 + "World!"
		}
		
		let g = {
			$0 + "Hello, "
		}

		XCTAssertTrue((f • g)(s) == "Hello, World!", "")
	}
}

