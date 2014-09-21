//
//  Foldable.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public protocol Foldable {
	typealias A
	typealias B

	typealias TA = K1<A>

// Uncomment to crash Swiftc
//	class func foldMap<M : Monoid>(A -> M) -> TA -> M
	class func foldr(A -> B -> B) -> B -> TA -> B
	class func foldl(B -> A -> B) -> B -> TA -> B
}

// Uncomment to crash Swiftc
//public func fold<N : Monoid, M : Monoid, FA : Foldable where FA.A == M>(f : FA) -> N {
//	return FA.foldMap(id)(f)
//}

extension Optional : Foldable {
	typealias TA = Optional<A>

// Uncomment to crash Swiftc
//	public static func foldMap<M : Monoid>(f : A -> M) -> Optional<A> -> M {
//		return { (let x) in
//			self.foldr(M.mappend • f)(M.mempty())(x)
//		}
//	}

	public static func foldr<B>(f : A -> B -> B) -> B -> Optional<A> -> B {
		return { (let z) in
			return { (let m) in
				switch m {
				case .None:
					return z
				case .Some(let x):
					return f(x)(z)
				}
			}
		}

	}

	public static func foldl<B>(f : B -> A -> B) -> B -> Optional<A> -> B {
		return { (let z) in
			return { (let m) in
				switch m {
					case .None:
						return z
					case .Some(let x):
						return f(z)(x)
				}
			}
		}
	}
}
