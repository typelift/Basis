//
//  Semigroup.swift
//  Basis
//
//  Created by Robert Widmann on 7/18/15.
//  Copyright © 2015 Robert Widmann. All rights reserved.
//

/// A Semigroup is a type with a closed, associative, binary operator.
public protocol Semigroup {
	
	/// An associative binary operator.
	func op(_ other : Self) -> Self
}

public func <> <A : Semigroup>(lhs : A, rhs : A) -> A {
	return lhs.op(rhs)
}

public func sconcat<S: Semigroup>(_ h : S, t : [S]) -> S {
	return t.reduce(h) { $0.op($1) }
}

extension List : Semigroup {
	public func op(_ other : List<A>) -> List<A> {
		return self + other
	}
}

extension Array : Semigroup {
	public func op(_ other : [Element]) -> [Element] {
		return self + other
	}
}

/// The monoid of booleans under conjunction
public struct All : Semigroup {
	public let getAll : Bool
	
	public init(_ val : Bool) {
		self.getAll = val
	}
	
	public func op(_ other : All) -> All {
		return All(self.getAll && other.getAll)
	}
}

/// The monoid of booleans under disjunction
public struct Any : Semigroup {
	public let getAny : Bool
	
	public init(_ val : Bool) {
		self.getAny = val
	}
	
	public func op(_ other : Any) -> Any {
		return Any(self.getAny || other.getAny)
	}
}

/// A monoid that `mappend`s its arguments flipped.
public struct Dual<A : Monoid> : Semigroup {
	public let getDual : A
	
	public init(_ dual : A) {
		self.getDual = dual
	}
	
	public func op(_ other : Dual<A>) -> Dual<A> {
		return Dual<A>(other.getDual <> self.getDual)
	}
}

/// The monoid of endomorphisms under composition.
public struct Endo<A> {
	public let appEndo : (A) -> A
	
	public init(_ ap : @escaping (A) -> A) {
		self.appEndo = ap
	}
	
	public func op(_ other : Endo<A>) -> Endo<A> {
		return 	Endo(self.appEndo • other.appEndo)
	}
}


/// The Semigroup of comparable values under MIN().
public struct Min<A : Comparable>: Semigroup {
	public let getMin : () -> A
	
	public init( _ x : @autoclosure @escaping () -> A) {
		getMin = x
	}
	
	public func op(_ other : Min<A>) -> Min<A> {
		if self.getMin() < other.getMin() {
			return self
		} else {
			return other
		}
	}
}

/// The Semigroup of comparable values under MAX().
public struct Max<A : Comparable> : Semigroup {
	public let getMax : () -> A
	
	public init( _ x : @autoclosure @escaping () -> A) {
		getMax = x
	}
	
	public func op(_ other : Max<A>) -> Max<A> {
		if other.getMax() < self.getMax() {
			return self
		} else {
			return other
		}
	}
}

/// The coproduct of `Semigroup`s
public struct Vacillate<A : Semigroup, B : Semigroup> : Semigroup {
	public let values : [Either<A, B>] // this array will never be empty
	
	public init(_ vs : [Either<A, B>]) {
		//		if vs.isEmpty {
		//			error("Cannot construct a \(Vacillate<A, B>.self) with no elements.")
		//		}
		var vals = [Either<A, B>]()
		for v in vs {
			if let z = vals.last {
				switch (z, v) {
				case let (.left(x), .left(y)): vals[vals.endIndex - 1] = Either.left(x.op(y))
				case let (.right(x), .right(y)): vals[vals.endIndex - 1] = Either.right(x.op(y))
				default: vals.append(v)
				}
			} else {
				vals = [v]
			}
		}
		self.values = vals
	}
	
	public static func left(_ x: A) -> Vacillate<A, B> {
		return Vacillate([Either.left(x)])
	}
	
	public static func right(_ y: B) -> Vacillate<A, B> {
		return Vacillate([Either.right(y)])
	}
	
	public func fold<C : Monoid>(onLeft f : @escaping (A) -> C, onRight g : @escaping (B) -> C) -> C {
		return values.reduce(C.mzero) { acc, v in  either(f)(g)(v).op(acc) }
	}
	
	public func op(_ other : Vacillate<A, B>) -> Vacillate<A, B> {
		return Vacillate(values + other.values)
	}
}
