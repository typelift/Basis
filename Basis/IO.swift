//
//  IO.swift
//  Basis
//
//  Created by Robert Widmann on 9/9/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

// The IO Monad is a means of representing a computation which, when performed, interacts with
// the outside world (i.e. performs effects) to arrive at some result of type A.
public final class IO<A> : K1<A> {
	internal let apply: World<RealWorld> -> (World<RealWorld>, A)

	init(apply: World<RealWorld> -> (World<RealWorld>, A)) {
		self.apply = apply
	}

	// The infamous "back door" to the IO Monad.  Forces strict evaluation
	// of the IO action and returns a result.
	public func unsafePerformIO() -> A  {
		return (snd • self.apply)(realWorld)
	}
}

/// Writes a character to standard output.
public func putChar(c : Character) -> IO<()> {
	return IO.pure(print(c))
}

/// Writes a string to standard output.
public func putStr(s : String) -> IO<()> {
	return IO.pure(print(s))
}

/// Writes a string and a newline to standard output.
public func putStrLn(s : String) -> IO<()> {
	return IO.pure(println(s))
}

/// Writes the description of an object to standard output.
public func print<A : Printable>(x : A) -> IO<()> {
	return putStrLn(x.description)
}

/// Gets a single character from standard input.
public func getChar() -> IO<Character> {
	return IO.pure(Character(UnicodeScalar(UInt32(getchar()))))
}

/// Gets a line of text from standard input.
public func getLine() -> IO<String> {
	return do_ { () -> String in
		var str : UnsafeMutablePointer<Int8> = nil
		var numBytes : UInt = 0;
		if getline(&str, &numBytes, stdin) == -1 {
			return ""
		}
		return String.fromCString(str)!
	}
}

/// Gets the entire contents of standard input.
public func getContents() -> IO<String> {
	return IO.pure(NSString(data: NSFileHandle.fileHandleWithStandardInput().availableData, encoding: NSUTF8StringEncoding) ?? "")
}

/// Takes a function that is given the contents of standard input.  The result of that function is
/// then output to standard out.
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
		return { (let io) in
			return IO<B>({ (let rw) in
				let (nw, a) = io.apply(rw)
				return (nw, f(a))
			})
		}
	}
}

public func <%><A, B>(f: A -> B, io : IO<A>) -> IO<B> {
	return IO.fmap(f)(io)
}

public func <% <A, B>(x : A, io : IO<B>) -> IO<A> {
	return IO.fmap(const(x))(io)
}

extension IO : Applicative {
	public class func pure(a: A) -> IO<A> {
		return IO<A>({ (let rw) in
			return (rw, a)
		})
	}

}

public func <*><A, B>(fn: IO<A -> B>, m: IO<A>) -> IO<B> {
	return IO<B>({ (let rw) in
		let f = fn.unsafePerformIO()
		let (nw, x) = m.apply(rw)
		return (nw, f(x))
	})
}

public func *> <A, B>(a : IO<A>, b : IO<B>) -> IO<B> {
	return const(id) <%> a <*> b
}

public func <* <A, B>(a : IO<A>, b : IO<B>) -> IO<A> {
	return const <%> a <*> b
}

extension IO : Monad {
	public func bind<B>(f: A -> IO<B>) -> IO<B> {
		return IO<B>({ (let rw) in
			let (nw, a) = self.apply(rw)
			return f(a).apply(nw)
		})
	}
}

public func >>-<A, B>(x: IO<A>, f: A -> IO<B>) -> IO<B> {
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

public func <-<A>(inout lhs: A?, rhs: IO<A>) {
	lhs = .Some(rhs.unsafePerformIO())
}

/// Wraps up a closure in a lazy IO action.
///
/// Do-notation is a special syntax taken from Haskell.  In Haskell, one uses do-notation as a 
/// shorthand for chains of Monadic operators, and for more "imperative-looking" code.  While Swift
/// does not allow us to define a DSL that specific, we can use the implicit sequencing of its 
/// imperative statements and call execution of those statements our "desugaring".
///
/// Generally, do-notation in the Basis is used around side-effecting code.  Do-blocks in Swift are
/// therefore more useful as a means of delimiting pure and side-effecting code from one another, 
/// while also retaining the benefits of the lazy IO monad.
///
/// It is important to note that IO actions returned are lazy.  This means the provided block will
/// not be executed until the values inside are requested, either with an extract (`<-`) or a call
/// to `unsafePerformIO()`
public func do_<A>(fn: () -> IO<A>) -> IO<A> {
	return IO<A>({ (let rw) in
		var x : A!
		x <- fn()
		return (rw, x)
	})
}

/// Wraps up a closure returning a value in a lazy IO action.
///
/// This variant of do-blocks allows one to write more natural looking code.  The return keyword
/// actually becomes monadic return.  For example
///
/// 	return do_ { () -> Unique in
///			var r : Int!
///			r <- modifyIORef(Unique.source)({ $0 + 1 }) >> readIORef(Unique.source)
///			return Unique(r)
///		}
public func do_<A>(fn: () -> A) -> IO<A> {
	return IO<A>({ (let rw) in
		return (rw, fn())
	})
}

/// Executes a list of IO actions sequentially, accumulating their results in a list in another IO
/// action
public func sequence<A>(ms : [IO<A>]) -> IO<[A]> {
	return foldr({ m in { n in
		do_ { () -> [A] in
			var x : A!
			var xs : [A]!

			x <- m
			xs <- n
			return [x] + xs
		}
	}})(IO.pure([]))(ms)
}

/// Executes a list of IO actions sequentially, discarding the result of each along the way.
public func sequence_<A>(ms : [IO<A>]) -> IO<()> {
	return foldr(curry(>>))(IO.pure(()))(ms)
}

/// Maps a function over a list, then sequences the resulting IO actions together, accumulating 
/// their results in a list in another IO action.
public func mapM<A, B>(f : A -> IO<B>) -> [A] -> IO<[B]> {
	return { ms in sequence(ms.map(f)) }
}

/// Maps a function over a list, then sequences the resulting IO actions together, discarding the
/// result of each along the way.
public func mapM_<A, B>(f : A -> IO<B>) -> [A] -> IO<()> {
	return { ms in sequence_(ms.map(f)) }
}

/// mapM with its arguments flipped around.
public func forM<A, B>(l: [A])(f : A -> IO<B>) -> IO<[B]> {
	return mapM(f)(l)
}

/// mapM_ with its arguments flipped around.
public func forM_<A, B>(l: [A])(f : A -> IO<B>) -> IO<()> {
	return mapM_(f)(l)
}

/// Herein lies the real world.  It is incredibly magic and sacred and not to be touched.  Those who
/// do rarely come out alive...
internal struct World<A> {}
internal protocol RealWorld {}

internal let realWorld = World<RealWorld>()
