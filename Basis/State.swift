//
//  State.swift
//  Basis
//
//  Created by Robert Widmann on 2/21/15.
//  Copyright (c) 2015 Robert Widmann. All rights reserved.
//

/// The lazy state monad represents a computation that threads an updatable piece of state through each step.
public struct State<S, A> {
	public let runState : (S) -> (A, S)
	
	public init(_ runState : @escaping (S) -> (A, S)) {
		self.runState = runState
	}
}

extension State : Functor {
	public typealias B = Swift.Any
	public typealias FB = State<S, B>
	
	public static func fmap<B>(_ f : @escaping (A) -> B) -> (State<S, A>) -> State<S, B> {
		return { state in
			return State<S, B>({ s in
				let (val, st2) = state.runState(s)
				return (f(val), st2)
			})
		}
	}
}

public func <^> <S, A, B>(f : @escaping (A) -> B, s : State<S, A>) -> State<S, B> {
	return State<S, A>.fmap(f)(s)
}

public func <% <S, A, B>(x : A, s : State<S, B>) -> State<S, A> {
	return (curry(<^>) • const)(x)(s)
}

public func %> <S, A, B>(s : State<S, B>, x : A) -> State<S, A> {
	return flip(<%)(s, x)
}

extension State : Pointed {
	public static func pure(_ x : A) -> State<S, A> {
		return State({ s in (x, s) })
	}
}

extension State : Applicative {
	public typealias FAB = State<S, (A) -> B>
	
	public static func ap<B>(_ stfn : State<S, (A) -> B>) -> (State<S, A>) -> State<S, B> {
		return { st in
			return stfn >>- { f in
				return st >>- { a in
					return State<S, B>.pure(f(a))
				}
			}
		}
	}
}

public func <*> <S, A, B>(f : State<S, (A) -> B> , s : State<S, A>) -> State<S, B> {
	return State<S, A>.ap(f)(s)
}

public func *> <S, A, B>(a : State<S, A>, b : State<S, B>) -> State<S, B> {
	return const(id) <^> a <*> b
}

public func <* <S, A, B>(a : State<S, A>, b : State<S, B>) -> State<S, A> {
	return const <^> a <*> b
}

extension State : ApplicativeOps {
	public typealias C = Any
	public typealias FC = State<S, C>
	public typealias D = Any
	public typealias FD = State<S, D>
	
	public static func liftA<B>(_ f : @escaping (A) -> B) -> (State<S, A>) -> State<S, B> {
		return { a in State<S, (A) -> B>.pure(f) <*> a }
	}
	
	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (State<S, A>) -> (State<S, B>) -> State<S, C> {
		return { a in { b in f <^> a <*> b  } }
	}
	
	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (State<S, A>) -> (State<S, B>) -> (State<S, C>) -> State<S, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension State : Monad {
	public func bind<B>(_ f : @escaping (A) -> State<S, B>) -> State<S, B> {
		return State<S, B>({ s in
			let (a, s2) = self.runState(s)
			return f(a).runState(s2)
		})
	}
}

public func >>- <S, A, B>(xs : State<S, A>, f : @escaping (A) -> State<S, B>) -> State<S, B> {
	return xs.bind(f)
}

public func >> <S, A, B>(x : State<S, A>, y : State<S, B>) -> State<S, B> {
	return x >>- { (_) in
		return y
	}
}

extension State : MonadOps {
	public typealias MLA = State<S, [A]>
	public typealias MLB = State<S, [B]>
	public typealias MU = State<S, ()>
	
	public static func mapM<B>(_ f : @escaping (A) -> State<S, B>) -> ([A]) -> State<S, [B]> {
		return { xs in State<S, B>.sequence(map(f)(xs)) }
	}
	
	public static func mapM_<B>(_ f : @escaping (A) -> State<S, B>) -> ([A]) -> State<S, ()> {
		return { xs in State<S, B>.sequence_(map(f)(xs)) }
	}
	
	public static func forM<B>(_ xs : [A]) -> ((A) -> State<S, B>) -> State<S, [B]> {
		return flip(State.mapM)(xs)
	}
	
	public static func forM_<B>(_ xs : [A]) -> ((A) -> State<S, B>) -> State<S, ()> {
		return flip(State.mapM_)(xs)
	}
	
	public static func sequence(_ ls : [State<S, A>]) -> State<S, [A]> {
		return foldr({ m, m2 in m >>- { x in m2 >>- { xs in State<S, [A]>.pure(cons(x)(xs)) } } })(State<S, [A]>.pure([]))(ls)
	}
	
	public static func sequence_(_ ls : [State<S, A>]) -> State<S, ()> {
		return foldr(>>)(State<S, ()>.pure(()))(ls)
	}
}

public func -<< <S, A, B>(f : @escaping (A) -> State<S, B>, xs : State<S, A>) -> State<S, B> {
	return xs.bind(f)
}

public func >>->> <S, A, B, C>(f : @escaping (A) -> State<S, B>, g : @escaping (B) -> State<S, C>) -> (A) -> State<S, C> {
	return { x in f(x) >>- g }
}

public func <<-<< <S, A, B, C>(g : @escaping (B) -> State<S, C>, f : @escaping (A) -> State<S, B>) -> (A) -> State<S, C> {
	return { x in f(x) >>- g }
}
