//
//  Maybe.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/11/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

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
