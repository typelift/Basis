//
//  Functions.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// Polymorphic identity function.
public func id<A>(x : A) -> A {
	return x
}

/// The constant combinator ignores its second argument and always returns its first argument.
public func const<A, B>(x : A) -> B -> A {
	return { (_) in
		return x
	}
}

/// Pipe Backward | Applies the function to its left to an argument on its right.
///
/// Chains of regular function applications are often made unnecessarily verbose and tedius by
/// large amounts of parenthesis.  Because this operator has a low precedence and is right-
/// associative, it can often be used to elide parenthesis such that the following holds:
///
///		f <| g <| h x  =  f (g (h x))
///
/// Haskellers will know this as the ($) combinator.
public func <|<A, B>(f : A -> B, x : A) -> B {
	return f(x)
}

/// Pipe Forward | Applies the argument on its left to a function on its right.
///
/// Sometimes, a computation looks more natural when data is computer first on the right side of
/// an expression and applied to a function on the left.
public func |><A, B>(x : A, f : A -> B) -> B {
	return f(x)
}

/// Function Composition | Composes the target of the left function with the source of the second
/// function to pipe the results through one larger function from left source to right target.
///
/// g . f x = g(f(x))
public func •<A, B, C>(f : B -> C, g : A -> B) -> A -> C {
	return { f(g($0)) }
}

/// The fixpoint combinator is a higher-order function that computes the fixed point of an equation.
/// That is, the point at which further application of x is the same x
///
///		x = f(x)
///
/// The fixpoint combinator models recursion in the untyped lambda calculus, and is notoriously
/// difficult to define and type in ML-style systems.  Especially because Swift is strict by default
/// we have to be incredibly careful and take an extra parameter to avoid infinite expansion of the
/// call tree.  Recursive functions must also be careful and include an extra level of lambda
/// abstraction (that is, take themselves as a parameter).
public func fix<A>(f : ((A -> A) -> A -> A))(x : A) -> A {
	return f(fix(f))(x)
}

/// On | Given a "combining" function and a function that converts arguments to the target of the
/// combiner, returns a function that applies the right hand side to two arguments, then runs both
/// results through the combiner.
public func |*|<A, B, C>(o : B -> B -> C, f : A -> B) -> A -> A -> C {
	return on(o)(f)
}

/// On | Given a "combining" function and a function that converts arguments to the target of the
/// combiner, returns a function that applies the right hand side to two arguments, then runs both
/// results through the combiner.
public func |*|<A, B, C>(o : (B, B) -> C, f : A -> B) -> A -> A -> C {
	return on(o)(f)
}

/// On | Given a "combining" function and a function that converts arguments to the target of the
/// combiner, returns a function that applies the right hand side to two arguments, then runs both
/// results through the combiner.
public func on<A, B, C>(o : B -> B -> C)(f : A -> B) -> A -> A -> C {
	return { (let x) in
		return {(let y) in 
			return o(f(x))(f(y))
		}
	}
}

/// On | Given a "combining" function and a function that converts arguments to the target of the
/// combiner, returns a function that applies the right hand side to two arguments, then runs both
/// results through the combiner.
public func on<A, B, C>(o : (B, B) -> C)(f : A -> B) -> A -> A -> C {
	return { (let x) in
		return {(let y) in 
			return o(f(x), f(y))
		}
	}
}

/// Returns a function with the position of the arguments switched.
public func flip<A, B, C>(f : A -> B -> C) -> B -> A -> C {
	return { (let b) in
		return { (let a) in
			return f(a)(b)
		}
	}
}

/// Returns an uncurried function with the position of the arguments in the tuple switched.
public func flip<A, B, C>(f : (A, B) -> C) -> (B, A) -> C {
	return { (let t) in
		return f(snd(t), fst(t))
	}
}

/// Applies a function to an argument until a given predicate returns true.
public func until<A>(p : A -> Bool)(f : A -> A)(x : A) -> A {
	if p(x) {
		return x
	}
	return until(p)(f: f)(x: f(x))
}

/// A type-restricted version of const.  In cases of typing ambiguity, using this function forces
/// its first argument to resolve to the type of the second argument.
public func asTypeOf<A>(x : A) -> A -> A {
	return const(x)
}

/// "As Type Of" | A type-restricted version of const.  In cases of typing ambiguity, using this 
/// function forces its first argument to resolve to the type of the second argument.  
///
/// Composed because it is the face one makes when having to tell the typechecker how to do its job.
public func >=<<A>(x : A, y : A) -> A {
	return asTypeOf(x)(y)
}

