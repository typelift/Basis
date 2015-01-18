//
//  Set.swift
//  Basis
//
//  Created by Robert Widmann on 10/3/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public enum SetD<A> {
	case Empty
	case Destructure(UInt, A, Set<A>!, Set<A>!)
}

/// An immutable set of values.
public final class Set<A> : K1<A> {
	let size : UInt
	let a : A!
	let l : Set<A>!
	let r : Set<A>!

	init(_ size : UInt, _ a : A!, _ l : Set<A>!, _ r : Set<A>!) {
		self.size = size
		self.a = a
		self.l = l
		self.r = r
	}

	public func match() -> SetD<A> {
		if self.size == 0 || a == nil {
			return .Empty
		}
		return .Destructure(size, a, l, r)
	}
}

/// Produces an empty set.
public func empty<A>() -> Set<A> {
	return Set<A>(0, nil, nil, nil)
}

/// Produces a set containing a single value.
public func singleton<A>(val : A) -> Set<A> {
	return Set<A>(1, val, nil, nil)
}

/// Returns whether a set is empty in constant time.
public func null<A>(m : Set<A>) -> Bool {
	switch m.match() {
		case .Empty:
			return true
		case .Destructure(_, _, _, _):
			return false
	}
}

/// Returns the size of a set in constant time.
public func size<A>(m : Set<A>) -> UInt {
	switch m.match() {
		case .Empty:
			return 0
		case .Destructure(let sz, _, _, _):
			return sz
	}
}

/// Returns whether a given key is a member of the set.
public func member<A : Comparable>(val : A) -> Set<A> -> Bool {
	return { m in
		switch m.match() {
			case .Empty:
				return false
			case let .Destructure(_, x, l, r):
				if val < x {
					return member(val)(l)
				} else if val > x {
					return member(val)(r)
				}
				return true
		}
	}
}

/// Returns whether a given key is not a member of the set.
public func notMember<A : Comparable>(val : A) -> Set<A> -> Bool {
	return { m in !member(val)(m) }
}

/// Inserts a value pair and returns a new set.
///
/// This function is left-biased in that it will replace any old value in the set with the new given
/// value if the two keys are the same.
public func insert<A : Comparable>(val : A) -> Set<A> -> Set<A> {
	return { s in
		switch s.match() {
			case .Empty:
				return singleton(val)
			case .Destructure(let sz, let y, let l, let r):
				if val < y {
					return balance(y)(l: insert(val)(l))(r: r)
				} else if val > y {
					return balance(y)(l: l)(r: insert(val)(r))
				}
				return Set(sz, val, l, r)
		}
	}
}

/// Deletes a value from the set and returns a new set.
///
/// If the value does not exist in the set, it is returned unmodified.
public func delete<A : Comparable>(k : A) -> Set<A> -> Set<A> {
	return { s in
		switch s.match() {
			case .Empty:
				return empty()
			case .Destructure(_, let x, let l, let r):
				if k < x {
					return balance(x)(l: delete(k)(s))(r: r)
				} else if k > x {
					return balance(x)(l: l)(r: delete(k)(s))
				}
				return glue(l, r)
		}
	}
}

/// Post-order fold of a function over the map.
public func foldr<A, B>(f : A -> B -> B) -> B -> Set<A> -> B {
	return  { z in { m in
		switch m.match() {
			case .Empty:
				return z
			case .Destructure(_, let x, let l, let r):
				return foldr(f)(f(x)(foldr(f)(z)(r)))(l)
		}
	} }
}

/// Post-order fold of an operator over the map.
public func foldr<A, B>(f : (A , B) -> B) -> B -> Set<A> -> B {
	return  { z in { m in
		switch m.match() {
			case .Empty:
				return z
			case .Destructure(_, let x, let l, let r):
				return foldr(f)(f(x, foldr(f)(z)(r)))(l)
		}
	} }
}

/// Pre-order fold of a function over the map.
public func foldl<A, B>(f: B -> A -> B) -> B -> Set<A> -> B {
	return  { z in { m in
		switch m.match() {
			case .Empty:
				return z
			case .Destructure(_, let x, let l, let r):
				return foldl(f)(f(foldl(f)(z)(l))(x))(r)
		}
	} }
}

/// Pre-order fold of an operator over the map.
public func foldl<A, B>(f: (B, A) -> B) -> B -> Set<A> -> B {
	return  { z in { m in
		switch m.match() {
			case .Empty:
				return z
			case .Destructure(_, let x, let l, let r):
				return foldl(f)(f(foldl(f)(z)(l), x))(r)
		}
	} }
}

/// Returns an array of all values in the set in ascending order of their keys.
public func elems<A>(m : Set<A>) -> [A] {
	return foldr(<|)([])(m)
}

/// Finds and deletes the minimal element in a set of ordered elements.
///
/// This function is partial with respect to empty sets.
public func deleteFindMin<A>(s : Set<A>) -> (A, Set<A>) {
	switch s.match() {
		case .Empty:
			return error("Cannot delete the minimal element of an empty set.")
		case .Destructure(_, let x, let l, let r):
			switch l.match() {
				case .Empty:
					return (x, r)
				case .Destructure(_, _, _, _):
					let (km, l1) = deleteFindMin(l)
					return (km, balance(x)(l: l1)(r: r))
			}
	}
}

/// Finds and deletes the maximal element in a set of ordered elements.
///
/// This function is partial with respect to empty sets.
public func deleteFindMax<A>(s : Set<A>) -> (A, Set<A>) {
	switch s.match() {
		case .Empty:
			return error("Cannot delete the maximal element of an empty set.")
		case .Destructure(_, let x, let l, let r):
			switch l.match() {
				case .Empty:
					return (x, r)
				case .Destructure(_, _, _, _):
					let (km, r1) = deleteFindMin(l)
					return (km, balance(x)(l: l)(r: r1))
			}
	}
}

/// Returns the difference of two sets.
public func difference<A : Comparable>(s1 : Set<A>) -> Set<A> -> Set<A> {
	return { s2 in
		switch s1.match() {
			case .Empty:
				return empty()
			case .Destructure(_, _, _, _):
				switch s2.match() {
					case .Empty:
						return s1
					case .Destructure(_, _, _, _):
						return hedgeDiff(.None, .None, s1, s2)
				}
		}
	}
}

/// Returns the union of two sets.
public func union<A : Comparable>(s1 : Set<A>) -> Set<A> -> Set<A> {
	return { s2 in
		switch s1.match() {
			case .Empty:
				return s1
			case .Destructure(_, _, _, _):
				switch s2.match() {
					case .Empty:
						return s1
					case .Destructure(_, _, _, _):
						return hedgeUnion(.None, .None, s1, s2)
				}
		}
	}
}

extension Set : Pointed {
	public class func pure(x : A) -> Set<A> {
		return singleton(x)
	}
}

/// Union and difference algorithms based on http://hackage.haskell.org/package/containers-0.5.5.1/docs/src/Data-Set-Base.html#union
private func hedgeUnion<A : Comparable>(blo : Optional<A>, bhi : Optional<A>, s1 : Set<A>, s2 : Set<A>) -> Set<A> {
	if s2.size == 0 {
		return s1
	}
	if s1.size == 0 {
		return link(s2.a, filterGt(blo, s2.l), filterLt(bhi, s2.r))
	}
	let bmi = Optional.Some(s1.a!)
	return link(s1.a, hedgeUnion(blo, bmi, s1.l, (trim(blo, bmi, s2))), hedgeUnion(bmi, bhi, s1.r, (trim(bmi, bhi, s2))))
}


private func hedgeDiff<A : Comparable>(blo : Optional<A>, bhi : Optional<A>, s1 : Set<A>, s2 : Set<A>) -> Set<A> {
	if s1.size == 0 {
		return empty()
	}
	if s2.size == 0 {
		return link(s1.a, filterGt(blo, s1.l), filterLt(bhi, s1.r))
	}
	let bmi = Optional.Some(s2.a!)
	return merge(hedgeDiff(blo, bmi, trim(blo, bmi, s1), s2.l), hedgeDiff(bmi, bhi, trim(bmi, bhi, s1), s2.r))
}


private func trim<A : Comparable>(m1 : Optional<A>, m2 : Optional<A>, s : Set<A>) -> Set<A> {
	if isNone(m1) && isNone(m2) {
		return s
	}

	if isSome(m1) && isNone(m2) {
		return greater(m1!, s)
	}

	if isNone(m1) && isSome(m2) {
		return lesser(m2!, s)
	}

	if isSome(m1) && isSome(m2) {
		return middle(m1!, m2!, s)
	}

	return s
}

private func greater<A : Comparable>(lo : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case let .Destructure(_, x, _, r) where x <= lo:
			return greater(lo, r)
		default:
			return s
	}
}

private func lesser<A : Comparable>(hi : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case let .Destructure(_, x, l, _) where x >= hi:
			return lesser(hi, l)
		default:
			return s
	}
}

private func middle<A : Comparable>(lo : A, hi : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case let .Destructure(_, x, _, r) where x <= lo:
			return middle(lo, hi, r)
		case let .Destructure(_, x, l, _) where x >= hi:
			return middle(lo, hi, l)
		default:
			return s
	}
}

private func filterGt<A : Comparable>(m : Optional<A>, s : Set<A>) -> Set<A> {
	switch m {
		case .None:
			return s
		case .Some(let b):
			return filterG(b, s)
	}
}

private func filterG<A : Comparable>(b : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case .Empty:
			assert(false, "")
		case let .Destructure(_, x, l, r):
			if b < x {
				return link(x, filterG(b, l), r)
			} else if b > x {
				return filterG(b, r)
			}
			return r
	}
}

private func filterLt<A : Comparable>(m : Optional<A>, s : Set<A>) -> Set<A> {
	switch m {
		case .None:
			return s
		case .Some(let b):
			return filterL(b, s)
	}
}

private func filterL<A : Comparable>(b : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case .Empty:
			assert(false, "")
		case let .Destructure(_, x, l, r):
			if b < x {
				return link(x, l, filterL(b, r))
			} else if b > x {
				return filterL(b, l)
			}
			return l
	}
}

/// Balancing based on unoptimized algorithm in Data.Set.Base
/// http://www.haskell.org/ghc/docs/7.8.3/html/libraries/containers-0.5.5.1/src/Data-Set-Base.html#balance
/// which is, in turn, based on the paper
/// http://groups.csail.mit.edu/mac/users/adams/BB/
private func balance<A>(x : A)(l : Set<A>)(r : Set<A>) -> Set<A> {
	if l.size + r.size <= 1 {
		return Set(l.size + r.size + 1, x, l, r)
	} else if r.size > l.size * 3 {
		return rotateL(x)(l: l)(r: r)
	} else if l.size > r.size * 3 {
		return rotateR(x)(l: l)(r: r)
	}
	return Set(l.size + r.size, x, l, r)
}

private func rotateL<A>(x : A)(l : Set<A>)(r : Set<A>) -> Set<A> {
	switch r.match() {
		case .Empty:
			return error("")
		case .Destructure(_, _, let ly, let ry):
			if ly.size < 2 * ry.size {
				return single(x)(t1: l)(t2: r)
			}
			return double(x)(t1: l)(t2: r)
	}
}

private func rotateR<A>(x : A)(l : Set<A>)(r : Set<A>) -> Set<A> {
	switch l.match() {
		case .Empty:
			return error("")
		case .Destructure(_, _, let ly, let ry):
			if ly.size < 2 * ry.size {
				return single(x)(t1: l)(t2: r)
			}
			return double(x)(t1: l)(t2: r)
	}
}

private func single<A>(x1 : A)(t1 : Set<A>)(t2 : Set<A>) -> Set<A> {
	switch t2.match() {
		case .Empty:
			switch t1.match() {
				case .Empty:
					return error("")
				case .Destructure(_, let x2, let t1, let t3):
					return bin(x2, t1, bin(x1, t3, t2))
			}
		case .Destructure(_, let x2, let t2, let t3):
			return bin(x2, bin(x1, t1, t2), t3)
	}
}

private func double<A>(x1 : A)(t1 : Set<A>)(t2 : Set<A>) -> Set<A> {
	switch t2.match() {
		case .Empty:
			switch t1.match() {
				case .Empty:
					return error("")
				case .Destructure(_, let x2, let b, let t4):
					switch b.match() {
						case .Empty:
							return error("")
						case .Destructure(_, let x3, let t2, let t3):
							return bin(x3, bin(x2, t1, t2), bin(x1, t3, t4))
					}
			}
		case .Destructure(_, let x2, let b, let t4):
			switch b.match() {
				case .Empty:
					return error("")
				case .Destructure(_, let x3, let t2, let t3):
					return bin(x3, bin(x1, t1, t2), bin(x2, t3, t4))
			}
	}
}

private func link<A>(x : A, l : Set<A>, r : Set<A>) -> Set<A> {
	switch l.match() {
		case .Empty:
			return insertMin(x, r)
		case let .Destructure(sizel, y, ly, ry):
			switch r.match() {
				case .Empty:
					return insertMax(x, l)
				case let .Destructure(sizer, z, lz, rz):
					if 3 * sizel < sizer {
						return balance(z)(l: link(x, l, lz))(r: rz)
					} else if 3 * sizer < sizel {
						return balance(y)(l: ly)(r: link(x, ry, r))
					}
					return bin(x, l, r)
			}
	}
}

private func insertMax<A>(x : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case .Empty:
			return singleton(x)
		case let .Destructure(_, y, l, r):
			return balance(y)(l: l)(r: insertMax(x, r))
	}
}

private func insertMin<A>(x : A, s : Set<A>) -> Set<A> {
	switch s.match() {
		case .Empty:
			return singleton(x)
		case let .Destructure(_, y, l, r):
			return balance(y)(l: insertMin(x, l))(r: r)
	}
}

private func merge<A>(l : Set<A>, r : Set<A>) -> Set<A> {
	switch l.match() {
		case .Empty:
			return r
		case let .Destructure(sizel, x, lx, rx):
			switch r.match() {
				case .Empty:
					return l
				case let .Destructure(sizer, y, ly, ry):
					if 3 * sizel < sizer {
						return balance(y)(l: merge(l, ly))(r: ry)
					} else if 3 * sizer < sizel {
						return balance(x)(l: lx)(r: merge(rx, r))
					}
					return glue(l, r)
			}
	}
}

private func glue<A>(l : Set<A>, r : Set<A>) -> Set<A> {
	if l.size == 0 {
		return r
	}
	if r.size == 0 {
		return l
	}

	if l.size > r.size {
		let (m, l1) = deleteFindMax(l)
		return balance(m)(l: l1)(r: r)
	}
	let (m, r1) = deleteFindMin(r)
	return balance(m)(l: l)(r: r1)
}

private func bin<A>(x : A, l : Set<A>, r : Set<A>) -> Set<A> {
	return Set(l.size + r.size + 1, x, l, r)
}
