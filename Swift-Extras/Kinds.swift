//
//  Kinds.swift
//  Swift-Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

/// MARK: Kinds
///
/// Kinds are the "Type of Types".  Or, more accurately, a specifier for the arity of a type's
/// default constructor.  Below is a hierarchy of kinds from *, all the way up to 
/// * -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *, where each * is a type in the Category of
/// Swift Types (S)

/// `*`
public class K0 {}

/// `* -> *`
public class K1<A> {}

/// `* -> * -> *`
public class K2<A, B> {}

/// `* -> * -> * -> *`
public class K3<A, B, C> {}

/// `* -> * -> * -> * -> *`
public class K4<A, B, C, D> {}

/// `* -> * -> * -> * -> * -> *`
public class K5<A, B, C, D, E> {}

/// `* -> * -> * -> * -> * -> * -> *`
public class K6<A, B, C, D, E, F> {}

/// `* -> * -> * -> * -> * -> * -> * -> *`
public class K7<A, B, C, D, E, F, G> {}

/// `* -> * -> * -> * -> * -> * -> * -> * -> *`
public class K8<A, B, C, D, E, F, G, H> {}

/// `* -> * -> * -> * -> * -> * -> * -> * -> * -> *`
public class K9<A, B, C, D, E, F, G, H, I> {}

/// `* -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *`
public class K10<A, B, C, D, E, F, G, H, I, J> {}

