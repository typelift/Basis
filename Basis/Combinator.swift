//
//  Combinator.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// The polymorphic identity function always returns the argument it was given.
///
/// Identities can be used to enforce a relationship between two types in the name of safety.  For 
/// example, concatenation is a function on arrays of arrays, but there isn't a built-in way to 
/// express an extension of [[T]].  By using the identity as a relation the compiler is forced to 
/// only allow `concat(_:)` to be invoked with nested arrays:
///
///     extension Array {
///         /// Concatenate an array of arrays.
///         func concat(rel : [T] -> [[U]]) -> [U] {
///             return foldr({ $0 + $1 })([])(rel(self))
///         }
///     }
///
///     let flat  = [[1, 2, 3], [4, 5]].concat(id) // [1, 2, 3, 4, 5]
///     // let error = [1, 2, 3, 4, 5].concat(id) // Does not typecheck
public func id<A>(_ x : A) -> A {
	return x
}

/// The constant combinator ignores its second argument and always returns its first argument.
public func const<A, B>(_ x : A) -> (B) -> A {
	return { (_) in
		return x
	}
}

/// Applies the second function to a value, then applies the first function to a value and the
/// result of the previous function application.
public func substitute<R, A, B>(_ f : @escaping (R) -> (A) -> B) -> ((R) -> A) -> (R) -> B {
	return { g in { x in f(x)(g(x)) } }
}

/// Applies the second function to a value, then applies the first function to a value and the
/// result of the previous function application.
public func substitute<R, A, B>(_ f : @escaping (R, A) -> B) -> ((R) -> A) -> (R) -> B {
	return { g in { x in f(x, g(x)) } }
}

/// Pipe Backward | Applies the function to its left to an argument on its right.
///
/// Chains of regular function applications are often made unnecessarily verbose and tedius by
/// large amounts of parenthesis.  Because this operator has a low precedence and is right-
/// associative, it can often be used to elide parenthesis such that the following holds:
///
///     f <<| g <<| h(x)  =  f (g (h (x)))
///
/// Haskellers will know this as the ($) combinator.
public func <| <A, B>(f : (A) -> B, x : A) -> B {
	return f(x)
}

/// Pipe Forward | Applies the argument on its left to a function on its right.
///
/// Sometimes, a computation looks more natural when a value is computed on the right side of
/// an expression and applied to a function on the left.  For example, this:
///
///     let result = and(zip(nubBy(==)(x))(y).map(==))
///		
/// can also be written as:
///
///     let result = nubBy(==)(x) |>> zip(y)
///                               |>> map(==)
///                               |>> and
public func |> <A, B>(x : A, f : (A) -> B) -> B {
	return f(x)
}

/// Function Composition | Composes the target of the left function with the source of the second
/// function to pipe the results through one larger function from right source to left target.
///
///     (g • f)(x) = g(f(x))
///
/// While the definition of this operator may seem backwards, it may help to read it as "after" to
/// see why it makes sense as-is.  As in:
///
///     h • g • f = 'h' after 'g' after 'f' 
public func • <A, B, C>(f : @escaping (B) -> C, g : @escaping (A) -> B) -> (A) -> C {
	return { f(g($0)) }
}

/// The fixpoint (or Y) combinator computes the least fixed point of an equation. That is, the first
/// point at which further application of x to a function is the same x.
///
///     x = f(x)
///
/// The fixpoint combinator models recursion in the untyped lambda calculus, and is notoriously
/// difficult to define and type in ML-style systems because it can often lead to paradoxes. Case in
/// point, the canonical definition of the Y combinator in Swift is as follows:
/// 
///     func Y() -> (A -> A) -> A {
///         return { f in
///             return ({ x in
///                 return f(x(x))
///             })({ x in
///                 return f(x(x))
///             })
///         }
///     }
///
/// This definition can never be typechecked by Swift because any instantiation of x must have the 
/// infinite type A : A -> B, or `A -> B -> C -> D -> E -> F -> G -> H -> I -> ...`
///
/// Because Swift is also strict by default, the traditional definition of the fixpoint combinator 
/// has been eta-expanded (i.e. it now takes itself as a parameter) to allow evaluation in constant 
/// stack space.  Without this kind of protection, fix would compute ⊥ by smashing the stack and 
/// crashing.
public func fix<A>(_ f : @escaping (((A) -> A) -> (A) -> A)) -> (A) -> A {
	return { x in f(fix(f))(x) }
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    f |*| g = { x in { y in f(g(x))(g(y)) } }
///
/// This function may be useful when a comparing two like objects using a given property, as in:
/// 
///     let arr : [(Int, String)] = [(2, "Second"), (1, "First"), (5, "Fifth"), (3, "Third"), (4, "Fourth")]
///     let sortedByFirstIndex = sortBy((<) |*| fst)(arr)
public func |*| <A, B, C>(o : (B) -> (B) -> C, f : (A) -> B) -> (A) -> (A) -> C {
	return on(o)(f)
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    (+) |*| f = { x, y in f(x) + f(y) }
///
/// This function may be useful when a comparing two like objects using a given property, as in:
/// 
///     let arr : [(Int, String)] = [(2, "Second"), (1, "First"), (5, "Fifth"), (3, "Third"), (4, "Fourth")]
///     let sortedByFirstIndex = sortBy((<) |*| fst)(arr)
public func |*| <A, B, C>(o : (B, B) -> C, f : (A) -> B) -> (A) -> (A) -> C {
	return on(o)(f)
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    (+) `|*|` f = { x, y in f(x) + f(y) }
public func on<A, B, C>(_ o : @escaping (B) -> (B) -> C) -> ((A) -> B) -> (A) -> (A) -> C {
	return { f in { x in { y in o(f(x))(f(y)) } } }
}

/// On | Applies the function on its right to both its arguments, then applies the function on its
/// left to the result of both prior applications.
///
///    (+) `|*|` f = { x, y in -> f(x) + f(y) }
public func on<A, B, C>(_ o : @escaping (B, B) -> C) -> ((A) -> B) -> (A) -> (A) -> C {
	return { f in { x in { y in o(f(x), f(y)) } } }
}

/// Returns a function with the position of the arguments switched.
public func flip<A, B, C>(_ f : @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
	return { b in { a in f(a)(b) } }
}

/// Returns an uncurried function with the position of the arguments in the tuple switched.
public func flip<A, B, C>(_ f : @escaping (A, B) -> C) -> (B, A) -> C {
	return { t in f(snd(t), fst(t)) }
}

/// A type-restricted version of const.  In cases of typing ambiguity, using this function forces
/// its first argument to resolve to the type of the second argument.
public func asTypeOf<A>(_ x : A) -> (A) -> A {
	return const(x)
}

/// "As Type Of" | A type-restricted version of const.  In cases of typing ambiguity, using this 
/// function forces its first argument to resolve to the type of the second argument.  
///
/// Composed because it is the face one makes when having to tell the typechecker how to do its job.
public func >-< <A>(x : A, y : A) -> A {
	return asTypeOf(x)(y)
}

/// Applies a function to an argument until a given predicate returns true.
public func until<A>(_ p : @escaping (A) -> Bool) -> ((A) -> A) -> (A) -> A {
	return { f in { x in p(x) ? x : until(p)(f)(f(x)) } }
}
