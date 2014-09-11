//
//  Monad.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// A Monad is an (Endo)Functor (but really, that doesn't matter because all Functors in Swift are
/// *technically* endofunctors) that respects a common-sense set of laws called the Monoid Laws:
///
/// - Closure    Composing two monads produces another monad.  Actually, the same monad, but with a
///              different value inside.  Basically, you cannot ever just compose a monad and
///              randomly come up with something that isn't a monad. The same is true of addition
///              and the integers.  All the numbers in the equation 1 + 1 = 2 are integers.  You
///              would never, in a million years, expect it to produce a real or complex or any
///              other type of number.
///
/// - Associativity    Composing a monad twice is the same whether you bunch your parenthesis up on
///                    the right side, or the left side. (1 + 1) + 1 = 1 + (1 + 1)
///
/// - Identity    There is some element in the set of possible parametrizations that, when composed
///               with other elements, doesn't alter their value.  Like 0 in addition of the
///               integers: 0 + 1 = 1 + 0 = 1
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
	typealias MB = K1<B>
	
	/// Bind is a function obtained by embedding a monad in a Kleisli Category.  It allows one to
	/// define a function that "shifts" the contents of the monad by some function, but still stay
	/// inside the monad.
	///
	/// Bind is famous because it allows one to build arbitrary pipes of computations with no effort
	/// at all.  You may have seen it notated >>=
	func bind(f : A -> MB) -> MB
}

public protocol MonadPlus : Monad {
	func mzero() -> FA
	func mplus(FA) -> FA -> FA
}
