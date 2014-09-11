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

public func <|<A, B>(f : A -> B, x : A) -> B {
	return f(x)
}

public func |><A, B>(x : A, f : A -> B) -> B {
	return f(x)
}

public func •<A, B, C>(f : B -> C, g : A -> B) -> A -> C {
	return { f(g($0)) }
}


public func fix<A>(f : A -> A) -> A {
	return f(fix(f))
}

public func |*|<A, B, C>(o : B -> B -> C, f : A -> B) -> A -> A -> C {
	return on(o)(f)
}

public func on<A, B, C>(o : B -> B -> C)(f : A -> B) -> A -> A -> C {
	return { (let x) in
		return {(let y) in 
			return o(f(x))(f(y))
		}
	}
}

public func maybe<A, B>(def : B)(f : A -> B)(m : Optional<A>) -> B {
	switch m {
		case .None:
			return def
		case .Some(let x):
			return f(x)
	}
}

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


public func until<A>(p : A -> Bool)(f : A -> A)(x : A) -> A {
	if p(x) {
		return x
	}
	return until(p)(f: f)(x: f(x))
}

public func asTypeOf<A>(x : A) -> A -> A {
	return const(x)
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



