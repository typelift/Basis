//
//  List.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

extension Array : Functor {
	typealias A = T
	typealias B = Any
	typealias FB = Array<B>
	
	public func fmap<B>(f: A -> B) -> Array<A> -> Array<B> {
		return { $0.map(f) }
	}
}

public func <^<A, B>(x : A, l : Array<B>) -> Array<A> {
	return l.fmap(const(x))(l)
}

extension Array : Applicative {
	typealias FAB = Array<A -> B>

	public func pure(x : A) -> Array<A> {
		return [x]
	}
}

//public func <*><A, B>(a : Array<A -> B> , l : Array<A>) -> Array<B> {
//	return
//}

//public func *><A, B>(a : Array<A>, b : Array<B>) -> Array<B> {
//	return const(id) <$> a <*> b
//}
//
//public func <*<A, B>(Array<A>, Array<B>) -> Array<A> {
//	return const <$> a <*> b
//}
