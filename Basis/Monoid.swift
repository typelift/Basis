//
//  Monoid.swift
//  Basis
//
//  Created by Robert Widmann on 9/10/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// Monoids are algebraic structures consisting of a set of elements, an associative binary operator
/// to combine two of those elements together, and a single specialized element called the identity 
/// (here, mempty) that respects the Monoid Laws:
///
/// - Closure    Composing two members of the set of elements yields another element still in that
///              set of elements.  This is much like addition over the integers where all the
///              numbers in the equation 1 + 1 = 2 are integers.  You would never, in a million 
///              years, expect it to produce a real or complex or any other type of number.  With
///
/// - Associativity    It does not matter which way you group your parenthesis when composing two
///                    members of the monoid's set.  Either way, the answer is the same.
///
/// - Identity    There is some element in the monoid's set of elements that, when composed
///               with other elements, doesn't alter their value.  Like 0 in addition of the
///               integers: 0 + 1 = 1 + 0 = 1
public protocol Monoid {
	typealias M

	/// The identity element.
	class func mempty() -> M
	
	/// An associative binary operator.
	class func mappend(M) -> M -> M
}

/// Mappend | An infix form of mappend for your convenience.
public func <><M : Monoid>(l : M.M, r : M.M) -> M.M {
	return M.mappend(l)(r)
}

public func mconcat<M, S: Monoid where S.M == M>(s: S, t: [M]) -> M {
	return (t.reduce(S.mempty()) { S.mappend($0)($1) })
}

/// A monoid that `mappend`s its arguments flipped.
public final class Dual<A> : K1<A> {
	let dual : A
	
	init(_ dual : A) {
		self.dual = dual
	}
}

/// The monoid of endomorphisms under composition.
public final class Endo<A> : K1<A> {
	let apply : A -> A
	
	init(_ ap : A -> A) {
		self.apply = ap
	}
}

extension Endo : Monoid {
	typealias M = Endo<A>
	
	public class func mempty() -> Endo<A> {
		return Endo(id)
	}
	
	public class func mappend(l : Endo<A>) -> Endo<A> -> Endo<A> {
		return { r in Endo(l.apply • r.apply) }
	}
}

/// The monoid of booleans under conjunction
public final class All {
	let val : Bool
	
	init(_ val : Bool) {
		self.val = val
	}
}

extension All : Monoid {
	typealias M = All
	
	public class func mempty() -> All {
		return All(true)
	}
	
	public class func mappend(l : All) -> All -> All {
		return { r in All(l.val && r.val) }
	}
}

/// The monoid of booleans under disjunction
public final class Any {
	let val : Bool
	
	init(_ val : Bool) {
		self.val = val
	}
}

extension Any : Monoid {
	typealias M = Any
	
	public class func mempty() -> Any {
		return Any(true)
	}
	
	public class func mappend(l : Any) -> Any -> Any {
		return { r in Any(l.val || r.val) }
	}
}

/// The left-biased maybe monoid.
public final class First<A> : K1<A> {
	let val : Maybe<A>
	
	init(_ val : Maybe<A>) {
		self.val = val
	}
}

extension First : Monoid {
	typealias M = First<A>
	
	public class func mempty() -> First<A> {
		return First(Maybe.nothing())
	}
	
	public class func mappend(l : First<A>) -> First<A> -> First<A> {
		return { r in First(maybe(r.val)(Maybe<A>.pure)(l.val)) }
	}
}

/// The right-biased maybe monoid.
public final class Last<A> : K1<A> {
	let val : Maybe<A>
	
	init(_ val : Maybe<A>) {
		self.val = val
	}
}

extension Last : Monoid {
	typealias M = Last<A>
	
	public class func mempty() -> Last<A> {
		return Last(Maybe.nothing())
	}
	
	public class func mappend(l : Last<A>) -> Last<A> -> Last<A> {
		return { r in Last(maybe(l.val)(Maybe<A>.pure)(r.val)) }
	}
}

//extension Array : Monoid {
//	typealias M = Array<T>
//
//	public static func mempty() -> Array<T> {
//		return []
//	}
//	
//	public static func mappend(l : Array<T>) -> Array<T> -> Array<T> {
//		return { l ++ $0 }
//	}
//}
