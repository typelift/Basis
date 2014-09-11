//
//  Monoid.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Monoid {
	class func mempty() -> Self
	class func mappend(Self) -> Self -> Self
}

//public func mconcat<M : Monoid>(l : [M]) -> M {
//	return foldr(M.mappend)(z: M.mempty())(lst: l)
//}

extension Array : Monoid {
	public static func mempty() -> Array<T> {
		 return []
	}
	
	public static func mappend(l : Array<T>) -> Array<T> -> Array<T> {
		return { l ++ $0 }
	}
}


