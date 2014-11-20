//
//  Version.swift
//  Basis
//
//  Created by Robert Widmann on 10/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Represents the version of a piece of software.
///
/// Versions are equal if they have the same number, value, and ordering of branch versions and the 
/// same tags that may not necessarily be in the same order.  
public final class Version : K0 {
	public let versionBranch : [Int]
	public let versionTags : [String]

	public init(_ versionBranch : [Int], _ versionTags : [String]) {
		self.versionBranch = versionBranch
		self.versionTags = versionTags
	}
}

extension Version : Equatable {}

public func ==(lhs : Version, rhs : Version) -> Bool {
	return lhs.versionBranch == rhs.versionBranch && sort(lhs.versionTags) == sort(rhs.versionTags)
}

extension Version : Printable {
	public var description : String {
		get {
			let versions = concat(intersperse(unpack("."))(self.versionBranch.map({ (let b : Int) in unpack(b.description) })))
			let tags = concatMap({ (let xs : [Character]) in unpack("-") + xs })(self.versionTags.map(unpack))
			return pack(versions + tags)
		}
	}
}
