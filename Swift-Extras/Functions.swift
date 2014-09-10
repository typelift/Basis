//
//  Functions.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public func id<A>(x : A) -> A {
	return x
}

public func not(x : Bool) -> Bool {
	return !x
}

public func fst<A, B>(t : (A, B)) -> A {
	return t.0
}

public func snd<A, B>(t : (A, B)) -> B {
	return t.1
}

public func maybe<A, B>(def : B)(f : A -> B)(m : Optional<A>) -> B {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return f(x)
	}
}

//public func either<A, B, C>(left : A -> C)(right : B -> C)(e : Either<A, B>) -> C {
//}

public func flip<A, B, C>(f : A -> B -> C) -> B -> A -> C {
	return { (let b) in
		return { (let a) in
			return f(a)(b)
		}
	}
}

public func flip<A, B, C>(f : (A, B) -> C) -> (B, A) -> C {
	return { (let t) in
		return f(t.1, t.0)
	}
}

public func const<A, B>(x : A) -> B -> A {
	return { (_) in
		return x
	}
}

public func error<A>(x : StaticString) -> A {
	assert(false, x)
}

public func uncurry<A, B, C>(f : A -> B -> C) -> (A, B) -> C {
	return { (let t) in
		return f(t.0)(t.1)
	}
}

public func curry<A, B, C>(f : (A, B) -> C) ->  A -> B -> C {
	return { (let a) in
		return { (let b) in
			return f((a, b))
		}
	}
}

public func swap<A, B>(t : (A, B)) -> (B, A) {
	return (t.1, t.0)
}

public func until<A>(p : A -> Bool)(f : A -> A)(x : A) -> A {
	if p(x) {
		return x
	}
	return until(p)(f: f)(x: f(x))
}

public func asTypeOf<A>(x : A) -> A -> A {
	return const(x)
}

public func undefined<A>() -> A {
	return error("Undefined")
}

public func putChar(c : Character) -> IO<()> {
	return IO.pure(print(c))
}

public func putStr(s : String) -> IO<()> {
	return IO.pure(print(s))
}

public func putStrLn(s : String) -> IO<()> {
	return IO.pure(println(s))
}


public func print<A : Printable>(x : A) -> IO<()> {
	return putStrLn(x.description)
}

//getChar         :: IO Char
//getChar         =  hGetChar stdin
//
//-- | Read a line from the standard input device
//-- (same as 'hGetLine' 'stdin').
//
//getLine         :: IO String
//getLine         =  hGetLine stdin
//

public func getContents() -> IO<String> {
	return IO.pure(NSString(data: NSFileHandle.fileHandleWithStandardInput().availableData, encoding: NSUTF8StringEncoding))
}

public func interact(f : String -> String) -> IO<()> {
	return do_ {
		var s : String = ""
		s <- getContents()
		return putStr(f(s))
	}
}



