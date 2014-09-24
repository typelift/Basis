//
//  Kinds.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

/// MARK: Kinds
///
/// Kinds are the "Type of Types".  Or, more accurately, a specifier for the arity of a type's
/// default constructor.  Below is a hierarchy of kinds from *, all the way up to 
/// * -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *, where each * is a type in the Category of
/// Swift Types (S)

/// `*`
public class K0 { public init() {} }

/// `* -> *`
public class K1<A> { public init() {} }

/// `* -> * -> *`
public class K2<A, B> { public init() {} }

/// `* -> * -> * -> *`
public class K3<A, B, C> { public init() {} }

/// `* -> * -> * -> * -> *`
public class K4<A, B, C, D> { public init() {} }

/// `* -> * -> * -> * -> * -> *`
public class K5<A, B, C, D, E> { public init() {} }

/// `* -> * -> * -> * -> * -> * -> *`
public class K6<A, B, C, D, E, F> { public init() {} }

/// `* -> * -> * -> * -> * -> * -> * -> *`
public class K7<A, B, C, D, E, F, G> { public init() {} }

/// `* -> * -> * -> * -> * -> * -> * -> * -> *`
public class K8<A, B, C, D, E, F, G, H> { public init() {} }

/// `* -> * -> * -> * -> * -> * -> * -> * -> * -> *`
public class K9<A, B, C, D, E, F, G, H, I> { public init() {} }

/// `* -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *`
public class K10<A, B, C, D, E, F, G, H, I, J> { public init() {} }

