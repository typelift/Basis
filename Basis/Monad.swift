//
//  Monad.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

/// A Monad is an (Endo)Functor (but really, that doesn't matter because all Functors in Swift are
/// *technically* endofunctors) that respects a common-sense set of laws called the Monoid Laws:
///
/// - Closure
///
///     - Composing two monads produces another monad.  Actually, the same monad, but with a
///       different value inside.  Basically, you cannot ever just compose a monad and
///       randomly come up with something that isn't a monad.
///
/// - Associativity    
///
///     - Composing a monad twice is the same whether you bunch your parenthesis up on
///       the right side, or the left side. (1 + 1) + 1 = 1 + (1 + 1)
///
/// - Identity    
///
///     - There is some element in the set of possible parametrizations that, when composed
///       with other elements, doesn't alter their value.  Like 0 in addition of the
///       integers: 0 + 1 = 1 + 0 = 1
///
/// A Monad lifts these laws into an algebraic structure and adds an all-important operator for
/// "sequencing" monads together.
///
/// Monads represent a computation in a "context".  If we make that context the "real world" we get
/// the IO Monad.  When that context is the surrounding spine in a structure, we get the List Monad.
///
/// When a chain of monads is built up (M<M<M<...A...>>>), computation is performed by removing an
/// outer M<...>.
public protocol Monad : Applicative {
	/// Bind is a function obtained by embedding a monad in a Kleisli Category.  It allows one to
	/// define a function that "shifts" the contents of the monad by some function, but still stay
	/// inside the monad.
	///
	/// Bind is famous because it allows one to build arbitrary pipes of computations with no effort
	/// at all.  You may have seen it notated >>-
	func bind(f : A -> FB) -> FB
	func >>-(Self, A -> FB) -> FB

	/// Sequence | Sequentially composes two monadic actions along the way discarding any value
	/// produced by the first action.
	func >><A, B>(Self, FB) -> FB
}

/// A monoid for monads.
public protocol MonadPlus : Monad {
	static func mzero() -> Self
	static func mplus(Self) -> Self -> Self
}

/// Additional functions to be implemented by those types conforming to the Monad protocol.
public protocol MonadOps : Monad {
	typealias C
	typealias FC = K1<C>

	typealias MLA = K1<[A]>
	typealias MLB = K1<[B]>
	typealias MU = K1<()>

	/// Maps a function taking values to Monadic actions, then evaluates each action in the 
	/// resulting list from left to right.  The results of each evaluated action are collected in
	/// another Monadic action.
	///
	/// Default Definition:
	///
	///     sequence(map(f)(xs))
	static func mapM(A -> FB) -> [A] -> MLB

	/// Maps a function taking values to Monadic actions, then evaluates each action in the
	/// resulting list from left to right.  The results of each evaluated action are discarded.
	///
	/// Default Definition:
	///
	///     sequence_(map(f)(xs))
	static func mapM_(A -> FB) -> [A] -> MU

	/// mapM with its arguments flipped.
	///
	/// Default Definition:
	///
	///     flip(mapM)(xs)
	static func forM([A]) -> (A -> FB) -> MLB

	/// mapM_ with its arguments flipped.
	///
	/// Default Definition:
	///
	///     flip(mapM_)(xs)
	static func forM_([A]) -> (A -> FB) -> MU

	/// Evaluates each Monadic action in sequence from left to right and collects the results in
	/// another Monadic action.
	///
	/// Default Definition:
	///
	///     foldr({ m, m2 in m >>- { x in m2 >>- { xs in pure(cons(x)(xs)) } } })(pure([]))(xs)
	static func sequence([Self]) -> MLA

	/// Evaluates each Monadic action in sequence from left to right discarding any intermediate
	/// results.
	///
	/// Default Definition:
	///
	///     foldr(>>)(pure(()))(xs)
	static func sequence_([Self]) -> MU


	/// Bind | Like bind but with its arguments flipped.
	func -<<(A -> FB, Self) -> FB

	/// Kleisli Forward | Kleisli composes two Monadic actions from the left to the right.
	func >->(A -> FB,  B -> FC) -> A -> FC

	/// Kleisli Backward | Kleisli composes two Monadic actions from the right to the left.
	func <-<(B -> FC, A -> FB) -> A -> FC
}
