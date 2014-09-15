//
//  String.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/14/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

extension String {
	public func destruct() -> ArrayD<Character> {
		return Array(self).destruct()
	}
}
