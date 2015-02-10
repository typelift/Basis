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
	static func mempty() -> M
	
	/// An associative binary operator.
	static func mappend(M) -> M -> M
	func <>(M, M) -> M
}

public func mconcat<M, S: Monoid where S.M == M>(s: S, t: [M]) -> M {
	return (t.reduce(S.mempty()) { S.mappend($0)($1) })
}

/// A monoid that `mappend`s its arguments flipped.
public struct Dual<A : Monoid> {
	public let getDual : A.M
	
	public init(_ dual : A.M) {
		self.getDual = dual
	}
}

extension Dual : Monoid {
	typealias M = Dual<A>
	
	public static func mempty() -> Dual<A> {
		return Dual<A>(A.mempty())
	}
	
	public static func mappend(l : Dual<A>) -> Dual<A> -> Dual<A> {
		return { r in Dual<A>(A.mappend(r.getDual)(l.getDual)) }
	}
}

public func <> <A : Monoid>(l : Dual<A>, r : Dual<A>) -> Dual<A> {
	return Dual.mappend(l)(r)
}

extension Dual : Pointed {
	public static func pure(x : A.M) -> Dual<A> {
		return Dual(x)
	}
}

extension Dual : Copointed {
	public func extract() -> A.M {
		return self.getDual
	}
}

/// The monoid of endomorphisms under composition.
public struct Endo<A> {
	public let appEndo : A -> A
	
	public init(_ ap : A -> A) {
		self.appEndo = ap
	}
}

extension Endo : Monoid {
	typealias M = Endo<A>
	
	public static func mempty() -> Endo<A> {
		return Endo(id)
	}
	
	public static func mappend(l : Endo<A>) -> Endo<A> -> Endo<A> {
		return { r in Endo(l.appEndo • r.appEndo) }
	}
}

public func <> <A>(l : Endo<A>, r : Endo<A>) -> Endo<A> {
	return Endo.mappend(l)(r)
}

extension Endo : Pointed {
	public static func pure(x : A -> A) -> Endo<A> {
		return Endo(x)
	}
}

/// The monoid of booleans under conjunction
public struct All {
	public let getAll : Bool
	
	public init(_ val : Bool) {
		self.getAll = val
	}
}

extension All : Monoid {
	typealias M = All
	
	public static func mempty() -> All {
		return All(true)
	}
	
	public static func mappend(l : All) -> All -> All {
		return { r in All(l.getAll && r.getAll) }
	}
}

public func <>(l : All, r : All) -> All {
	return All.mappend(l)(r)
}

/// The monoid of booleans under disjunction
public struct Any {
	public let getAny : Bool
	
	public init(_ val : Bool) {
		self.getAny = val
	}
}

extension Any : Monoid {
	typealias M = Any
	
	public static func mempty() -> Any {
		return Any(false)
	}
	
	public static func mappend(l : Any) -> Any -> Any {
		return { r in Any(l.getAny || r.getAny) }
	}
}

public func <>(l : Any, r : Any) -> Any {
	return Any.mappend(l)(r)
}

/// The monoid of arithmetic types under addition.
public struct Sum<A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>> {
	public let getSum : A
	
	public init(_ sum : A) {
		self.getSum = sum
	}
}

extension Sum : Monoid {
	typealias M = Sum
	
	public static func mempty() -> Sum {
		return Sum(0)
	}
	
	public static func mappend(l : Sum) -> Sum -> Sum {
		return { r in Sum(l.getSum + r.getSum) }
	}
}

public func <> <A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(l : Sum<A>, r : Sum<A>) -> Sum<A> {
	return Sum.mappend(l)(r)
}

extension Sum : Pointed {
	public static func pure(x : A) -> Sum<A> {
		return Sum(x)
	}
}

extension Sum : Copointed {
	public func extract() -> A {
		return self.getSum
	}
}

/// The monoid of arithmetic types under multiplication.
public struct Product<A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>> {
	public let getProduct : A
	
	public init(_ product : A) {
		self.getProduct = product
	}
}

extension Product : Monoid {
	typealias M = Product
	
	public static func mempty() -> Product {
		return Product(1)
	}
	
	public static func mappend(l : Product) -> Product -> Product {
		return { r in Product(l.getProduct * r.getProduct) }
	}
}
	
public func <> <A : protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(l : Product<A>, r : Product<A>) -> Product<A> {
	return Product.mappend(l)(r)
}

extension Product : Pointed {
	public static func pure(x : A) -> Product<A> {
		return Product(x)
	}
}

extension Product : Copointed {
	public func extract() -> A {
		return self.getProduct
	}
}

/// The left-biased maybe monoid.
public struct First<A> {
	public let getFirst : Maybe<A>
	
	public init(_ val : Maybe<A>) {
		self.getFirst = val
	}
}

extension First : Monoid {
	typealias M = First<A>
	
	public static func mempty() -> First<A> {
		return First(Maybe.nothing())
	}
	
	public static func mappend(l : First<A>) -> First<A> -> First<A> {
		return { r in First(maybe(r.getFirst)(Maybe<A>.pure)(l.getFirst)) }
	}
}

public func <> <A>(l : First<A>, r : First<A>) -> First<A> {
	return First.mappend(l)(r)
}

extension First : Pointed {
	public static func pure(x : A) -> First<A> {
		return First(Maybe(x))
	}
}

//extension First : Copointed {
//	public func extract() -> Maybe<A> {
//		return self.getFirst
//	}
//}

/// The right-biased maybe monoid.
public struct Last<A> {
	public let getLast : Maybe<A>
	
	public init(_ val : Maybe<A>) {
		self.getLast = val
	}
}

extension Last : Monoid {
	typealias M = Last<A>
	
	public static func mempty() -> Last<A> {
		return Last(Maybe.nothing())
	}
	
	public static func mappend(l : Last<A>) -> Last<A> -> Last<A> {
		return { r in Last(maybe(l.getLast)(Maybe<A>.pure)(r.getLast)) }
	}
}

public func <> <A>(l : Last<A>, r : Last<A>) -> Last<A> {
	return Last.mappend(l)(r)
}

extension Last : Pointed {
	public static func pure(x : A) -> Last<A> {
		return Last(Maybe(x))
	}
}

//extension Last : Copointed {
//	public func extract() -> Maybe<A> {
//		return self.getLast
//	}
//}

/// The monoid of ordered values under max.
public struct Max<A : protocol<Comparable, Bounded>> {
	public let getMax : A
	
	public init(_ max : A) {
		self.getMax = max
	}
}

extension Max : Monoid {
	typealias M = Max<A>
	
	public static func mempty() -> Max<A> {
		return Max(A.minBound())
	}
	
	public static func mappend(l : Max<A>) -> Max<A> -> Max<A> {
		return { r in Max(max(l.getMax, r.getMax)) }
	}
}

public func <> <A : protocol<Comparable, Bounded>>(l : Max<A>, r : Max<A>) -> Max<A> {
	return Max.mappend(l)(r)
}

extension Max : Pointed {
	public static func pure(x : A) -> Max<A> {
		return Max(x)
	}
}

extension Max : Copointed {
	public func extract() -> A {
		return self.getMax
	}
}

/// The monoid of ordered values under min.
public struct Min<A : protocol<Comparable, Bounded>> {
	public let getMin : A
	
	public init(_ min : A) {
		self.getMin = min
	}
}

extension Min : Monoid {
	typealias M = Min<A>
	
	public static func mempty() -> Min<A> {
		return Min(A.maxBound())
	}
	
	public static func mappend(l : Min<A>) -> Min<A> -> Min<A> {
		return { r in Min(min(l.getMin, r.getMin)) }
	}
}

public func <> <A : protocol<Comparable, Bounded>>(l : Min<A>, r : Min<A>) -> Min<A> {
	return Min.mappend(l)(r)
}

extension Min : Pointed {
	public static func pure(x : A) -> Min<A> {
		return Min(x)
	}
}

extension Min : Copointed {
	public func extract() -> A {
		return self.getMin
	}
}

/// A Monoid over Strings.
extension String : Monoid {
	typealias M = String

	public static func mempty() -> String {
		return ""
	}

	public static func mappend(l : String) -> String -> String {
		return { r in l + r }
	}
}

public func <>(l : String, r : String) -> String {
	return l + r
}

/// MARK: Equatable

public func ==<A : Monoid where A.M : Equatable>(lhs : Dual<A>, rhs : Dual<A>) -> Bool {
	return lhs.getDual == rhs.getDual
}

public func !=<A : Monoid where A.M : Equatable>(lhs: Dual<A>, rhs: Dual<A>) -> Bool {
	return !(lhs == rhs)
}

public func ==(lhs : All, rhs : All) -> Bool {
	return lhs.getAll == rhs.getAll
}

public func !=(lhs: All, rhs: All) -> Bool {
	return !(lhs == rhs)
}

public func ==(lhs : Any, rhs : Any) -> Bool {
	return lhs.getAny == rhs.getAny
}

public func !=(lhs: Any, rhs: Any) -> Bool {
	return !(lhs == rhs)
}

public func ==<A : Equatable>(lhs : First<A>, rhs : First<A>) -> Bool {
	return lhs.getFirst == rhs.getFirst
}

public func !=<A : Equatable>(lhs: First<A>, rhs: First<A>) -> Bool {
	return !(lhs == rhs)
}

public func ==<A : Equatable>(lhs : Last<A>, rhs : Last<A>) -> Bool {
	return lhs.getLast == rhs.getLast
}

public func !=<A : Equatable>(lhs: Last<A>, rhs: Last<A>) -> Bool {
	return !(lhs == rhs)
}

public func ==<A : protocol<Comparable, Bounded, Equatable>>(lhs : Max<A>, rhs : Max<A>) -> Bool {
	return lhs.getMax == rhs.getMax
}

public func !=<A : protocol<Comparable, Bounded, Equatable>>(lhs: Max<A>, rhs: Max<A>) -> Bool {
	return !(lhs == rhs)
}

public func ==<A : protocol<Comparable, Bounded, Equatable>>(lhs : Min<A>, rhs : Min<A>) -> Bool {
	return lhs.getMin == rhs.getMin
}

public func !=<A : protocol<Comparable, Bounded, Equatable>>(lhs: Min<A>, rhs: Min<A>) -> Bool {
	return !(lhs == rhs)
}

public func ==<T : protocol<IntegerArithmeticType, IntegerLiteralConvertible, Equatable>>(lhs: Sum<T>, rhs: Sum<T>) -> Bool {
	return lhs.getSum == rhs.getSum
}

public func !=<T : protocol<IntegerArithmeticType, IntegerLiteralConvertible, Equatable>>(lhs: Sum<T>, rhs: Sum<T>) -> Bool {
	return !(lhs == rhs)
}

public func ==<T : protocol<IntegerArithmeticType, IntegerLiteralConvertible, Equatable>>(lhs: Product<T>, rhs: Product<T>) -> Bool {
	return lhs.getProduct == rhs.getProduct
}

public func !=<T : protocol<IntegerArithmeticType, IntegerLiteralConvertible, Equatable>>(lhs: Product<T>, rhs: Product<T>) -> Bool {
	return !(lhs == rhs)
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
