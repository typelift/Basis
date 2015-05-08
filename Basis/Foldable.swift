//
//  Foldable.swift
//  Basis-iOS
//
//  Created by Robert Widmann on 2/6/15.
//  Copyright (c) 2015 Robert Widmann. All rights reserved.
//

protocol Foldable {
	func fold<M : Monoid>
}