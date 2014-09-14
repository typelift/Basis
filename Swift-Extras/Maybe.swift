//
//  Maybe.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/11/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func maybe<A, B>(def : B)(f : A -> B)(m : Optional<A>) -> B {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return f(x)
	}
}

public func isSome<A>(o : Optional<A>) -> Bool {
	switch o {
		case .None:
			return false
		default:
			return true
	}
}

public func isNone<A>(o : Optional<A>) -> Bool {
	switch o {
		case .None:
			return true
		default:
			return false
	}
}

public func fromOptional<A>(def : A)(m : Optional<A>) -> A {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return x
	}
}

public func optionalToList<A>(o : Optional<A>) -> [A] {
	switch o {
		case .None:
			return []
		case .Some(let x):
			return [x]
	}
}

public func listToOptional<A>(l : [A]) -> Optional<A> {
	switch l.destruct() {
		case .Empty:
			return .None
		case .Destructure(let x, _):
			return .Some(x)
	}
}

public func catOptionals<A>(l : [Optional<A>]) -> [A] {
	return concatMap(optionalToList)(l: l)
}

public func mapOptional<A, B>(f : A -> Optional<B>)(l : [A]) -> [B] {
	switch l.destruct() {
		case .Empty:
			return []
		case .Destructure(let x, let xs):
			let rs = mapOptional(f)(l: xs)
			switch f(x) {
				case .None:
					return rs
				case .Some(let r):
					return r +> rs
		}
	}
}

extension Optional : Functor {
	typealias A = T
	typealias B = Any
	
	typealias FA = Optional<A>
	typealias FB = Optional<B>
	

	public static func fmap<B>(f : A -> B) -> Optional<A> -> Optional<B> {
		return {			
			switch $0 {
				case .None:
					return .None
				case .Some(let x):
					return .Some(f(x))
			}
		}
	}
}

public func <%><A, B>(f : A -> B, o : Optional<A>) -> Optional<B> {
	return Optional.fmap(f)(o)
}

public func <^<A, B>(x : A, o : Optional<B>) -> Optional<A> {
	return defaultReplace(Optional.fmap)(x: x)(f: o)
}

extension Optional : Applicative {
	typealias FAB = Optional<A -> B>
	
	public static func pure(x : A) -> Optional<A> {
		return .Some(x)
	}
}

public func <*><A, B>(f : Optional<A -> B> , o : Optional<A>) -> Optional<B> {
	switch f {
		case .None:
			return .None
		case .Some(let f):
			return f <%> o
	}
}


public func *><A, B>(a : Optional<A>, b : Optional<B>) -> Optional<B> {
	return const(id) <%> a <*> b
}

public func <*<A, B>(a : Optional<A>, b : Optional<B>) -> Optional<A> {
	return const <%> a <*> b
}

extension Optional : Applicative {
	typealias FLA = Optional<[A]>
	
	public func empty() -> Optional<A> {
		return .None
	}
	
	public func some(v : Optional<A>) -> Optional<[A]> {
		return curry((+>)) <%> v <*> many(v)
	}
	
	public func many(v : Optional<A>) -> Optional<[A]> {
		return some(v) <|> Optional<[A]>.pure([])
	}
}

public func <|><A>(l : Optional<A>, r : Optional<A>) -> Optional<A> {
	switch l {
		case .None:
			return r
		case .Some(_):
			return l
	}
}

extension Optional : Monad {	
	public func bind<B>(f : A -> Optional<B>) -> Optional<B> {
		switch self {
			case .None:
				return .None
			case .Some(let x):
				return f(x)
		}
	}
}

public func >>=<A, B>(x : Optional<A>, f : A -> Optional<B>) -> Optional<B> {
	return x.bind(f)
}


extension Optional : MonadPlus {
	public func mzero() -> Optional<A> {
		return .None
	}
	
	public func mplus(l : Optional<A>) -> Optional<A> -> Optional<A> {
		return {
			switch l {
				case .None:
					return $0
				default:
					return l
			}
		}
	}
}
