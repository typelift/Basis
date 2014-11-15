//
//  VersionSpec.swift
//  Basis
//
//  Created by Robert Widmann on 10/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Basis
import XCTest


class VersionSpec : XCTestCase {
	func testVersion() {
		let branches = [1,2,3]
		let tags = ["tag1", "tag2"]

		XCTAssertTrue(Version(branches, tags).description == "1.2.3-tag1-tag2", "")
	}
}


