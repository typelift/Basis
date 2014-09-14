//
//  IO.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

infix operator <- {}

// The IO Monad is a means of representing a computation which, when performed, interacts with
// the outside world (i.e. performs effects) to arrive at some result of type a.
public final class IO<A> : K1<A> {	
	let apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)

	init(apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)) {
		self.apply = apply
	}
	
	// The infamous "back door" to the IO Monad.  Forces strict evaluation
	// of the IO action and returns a result.
	public func unsafePerformIO() -> A  {
		return self.apply(rw: realWorld).1
	}

	public func map<B>(f: A -> B) -> IO<B> {
		return IO<B>({ (let rw) in
			let (nw, a) = self.apply(rw: rw)
			return (nw, f(a))
		})
	}
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

public func getChar() -> IO<Character> {
	return IO.pure(Character(UnicodeScalar(UInt32(getchar()))))
}

public func getLine() -> IO<String> {
	var str : UnsafeMutablePointer<Int8> = nil
	var numBytes : UInt = 0;
	if getline(&str, &numBytes, stdin) == -1 {
		return IO.pure("")
	}
	return IO.pure(String.fromCString(str)!)
}

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

extension IO : Functor {
	typealias FA = IO<A>
	typealias B = Any
	
	public class func fmap<B>(f: A -> B) -> IO<A> -> IO<B> {
		return { $0.map(f) }
	}
}

public func <%><A, B>(f: A -> B, io : IO<A>) -> IO<B> {
	return IO.fmap(f)(io)
}

public func <^ <A, B>(x : A, io : IO<B>) -> IO<A> {
	return IO.fmap(const(x))(io)
}


extension IO : Applicative {
	public class func pure(a: A) -> IO<A> {
		return IO<A>({ (let rw) in
			return (rw, a)
		})
	}
	
	public func ap<B>(fn: IO<A -> B>) -> IO<B> {
		return IO<B>({ (let rw) in
			let f = fn.unsafePerformIO()
			let (nw, x) = self.apply(rw: rw)
			return (nw, f(x))
		})
	}
}

extension IO : Monad {
	public func bind<B>(f: A -> IO<B>) -> IO<B> {
		return IO<B>({ (let rw) in
			let (nw, a) = self.apply(rw: rw)
			return f(a).apply(rw: nw)
		})
	}
}

public func <*><A, B>(mf: IO<A -> B>, m: IO<A>) -> IO<B> {
	return m.ap(mf)
}

public func *> <A, B>(a : IO<A>, b : IO<B>) -> IO<B> {
	return const(id) <%> a <*> b
}

public func <* <A, B>(a : IO<A>, b : IO<B>) -> IO<A> {
	return const <%> a <*> b
}

public func >>=<A, B>(x: IO<A>, f: A -> IO<B>) -> IO<B> {
	return x.bind(f)
}

public func >><A, B>(x: IO<A>, y: IO<B>) -> IO<B> {
	return x.bind({ (_) in
		return y
	})
}

public func <-<A>(inout lhs: A, rhs: IO<A>) {
	lhs = rhs.unsafePerformIO()
}

public func <-<A>(inout lhs: A!, rhs: IO<A>) {
	lhs = rhs.unsafePerformIO()
}

public func do_<A>(fn: () -> A) -> IO<A> {
	return IO.pure(fn())
}

public func do_<A>(fn: () -> IO<A>) -> IO<A> {
	return fn()
}

/// Herein lies the real world.  It is incredibly magic and sacred and not to be touched.  Those who
/// do rarely come out alive...
internal struct World<A> {}
internal protocol RealWorld {}

internal let realWorld = World<RealWorld>()
