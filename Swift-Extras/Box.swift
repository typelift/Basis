//
//  Box.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

/// The infamous Box Hack.  Oh, how I'd love to say this was a Sort.  Let's hope we get ADTs soon...
///
/// But as long as I have the space, Sorts are the type of Kinds which are the type of types.  As
/// with Kinds, that's not necessarily the best way to think about them.  In fact, it's better to 
/// not think of Sorts at all because there really is only one, called BOX, in Haskell, and it is
/// fairly useless.
public final class Box<A> : K1<A> {
	public let unBox : () -> A
	
	public init(_ x : A) {
		unBox = { x }
	}
}
