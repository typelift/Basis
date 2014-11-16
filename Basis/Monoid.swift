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
	func <>(M, M) -> M
}

public func mconcat<M, S: Monoid where S.M == M>(s: S, t: [M]) -> M {
	return (t.reduce(S.mempty()) { S.mappend($0)($1) })
}

/// A monoid that `mappend`s its arguments flipped.
public final class Dual<A> : K1<A> {
	public let dual : A
	
	public init(_ dual : A) {
		self.dual = dual
	}
}

/// The monoid of endomorphisms under composition.
public final class Endo<A> : K1<A> {
	public let appEndo : A -> A
	
	public init(_ ap : A -> A) {
		self.appEndo = ap
	}
}

extension Endo : Monoid {
	typealias M = Endo<A>
	
	public class func mempty() -> Endo<A> {
		return Endo(id)
	}
	
	public class func mappend(l : Endo<A>) -> Endo<A> -> Endo<A> {
		return { r in Endo(l.appEndo • r.appEndo) }
	}
}

public func <><A>(l : Endo<A>, r : Endo<A>) -> Endo<A> {
	return Endo.mappend(l)(r)
}

/// The monoid of booleans under conjunction
public final class All {
	public let getAll : Bool
	
	public init(_ val : Bool) {
		self.getAll = val
	}
}

extension All : Monoid {
	typealias M = All
	
	public class func mempty() -> All {
		return All(true)
	}
	
	public class func mappend(l : All) -> All -> All {
		return { r in All(l.getAll && r.getAll) }
	}
}

public func <>(l : All, r : All) -> All {
	return All.mappend(l)(r)
}

/// The monoid of booleans under disjunction
public final class Any {
	public let getAny : Bool
	
	public init(_ val : Bool) {
		self.getAny = val
	}
}

extension Any : Monoid {
	typealias M = Any
	
	public class func mempty() -> Any {
		return Any(false)
	}
	
	public class func mappend(l : Any) -> Any -> Any {
		return { r in Any(l.getAny || r.getAny) }
	}
}

public func <>(l : Any, r : Any) -> Any {
	return Any.mappend(l)(r)
}

/// The monoid of arithmetic types under addition.
public final class Sum<A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>> {
	public let getSum : A
	
	public init(_ sum : A) {
		self.getSum = sum
	}
}

extension Sum : Monoid {
	typealias M = Sum
	
	public class func mempty() -> Sum {
		return Sum(0)
	}
	
	public class func mappend(l : Sum) -> Sum -> Sum {
		return { r in Sum(l.getSum + r.getSum) }
	}
}

public func <><A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(l : Sum<A>, r : Sum<A>) -> Sum<A> {
	return Sum.mappend(l)(r)
}

/// The monoid of arithmetic types under multiplication.
public final class Product<A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>> {
	public let getProduct : A
	
	public init(_ product : A) {
		self.getProduct = product
	}
}

extension Product : Monoid {
	typealias M = Product
	
	public class func mempty() -> Product {
		return Product(1)
	}
	
	public class func mappend(l : Product) -> Product -> Product {
		return { r in Product(l.getProduct * r.getProduct) }
	}
}
	
public func <><A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(l : Product<A>, r : Product<A>) -> Product<A> {
	return Product.mappend(l)(r)
}

/// The left-biased maybe monoid.
public final class First<A> : K1<A> {
	public let getFirst : Maybe<A>
	
	public init(_ val : Maybe<A>) {
		self.getFirst = val
	}
}

extension First : Monoid {
	typealias M = First<A>
	
	public class func mempty() -> First<A> {
		return First(Maybe.nothing())
	}
	
	public class func mappend(l : First<A>) -> First<A> -> First<A> {
		return { r in First(maybe(r.getFirst)(Maybe<A>.pure)(l.getFirst)) }
	}
}

public func <><A>(l : First<A>, r : First<A>) -> First<A> {
	return First.mappend(l)(r)
}

/// The right-biased maybe monoid.
public final class Last<A> : K1<A> {
	public let getLast : Maybe<A>
	
	public init(_ val : Maybe<A>) {
		self.getLast = val
	}
}

extension Last : Monoid {
	typealias M = Last<A>
	
	public class func mempty() -> Last<A> {
		return Last(Maybe.nothing())
	}
	
	public class func mappend(l : Last<A>) -> Last<A> -> Last<A> {
		return { r in Last(maybe(l.getLast)(Maybe<A>.pure)(r.getLast)) }
	}
}

public func <><A>(l : Last<A>, r : Last<A>) -> Last<A> {
	return Last.mappend(l)(r)
}

/// The monoid of ordered values under max.
public final class Max<A : protocol<Comparable, Bounded>> : K1<A> {
	public let getMax : A
	
	public init(_ max : A) {
		self.getMax = max
	}
}

extension Max : Monoid {
	typealias M = Max<A>
	
	public class func mempty() -> Max<A> {
		return Max(A.minBound())
	}
	
	public class func mappend(l : Max<A>) -> Max<A> -> Max<A> {
		return { r in Max(max(l.getMax, r.getMax)) }
	}
}

public func <><A : protocol<Comparable, Bounded>>(l : Max<A>, r : Max<A>) -> Max<A> {
	return Max.mappend(l)(r)
}

/// The monoid of ordered values under min.
public final class Min<A : protocol<Comparable, Bounded>> : K1<A> {
	public let getMin : A
	
	public init(_ min : A) {
		self.getMin = min
	}
}

extension Min : Monoid {
	typealias M = Min<A>
	
	public class func mempty() -> Min<A> {
		return Min(A.maxBound())
	}
	
	public class func mappend(l : Min<A>) -> Min<A> -> Min<A> {
		return { r in Min(min(l.getMin, r.getMin)) }
	}
}

public func <><A : protocol<Comparable, Bounded>>(l : Min<A>, r : Min<A>) -> Min<A> {
	return Min.mappend(l)(r)
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
