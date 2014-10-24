//
//  Exception.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public protocol Exception : Printable {	}

public struct SomeException : Exception {
	public var description : String
	
	init(_ desc : String) {
		self.description = desc
	}
}

public func throw<A>(e : Exception) -> A {
	assert(false, e.description)
}

public func throwIO<A>(e : Exception) -> IO<A> {
	return do_ { () -> A in
		return throw(e)
	}
}

public func catchException<A>(io : IO<A>)(handler: Exception -> IO<A>) -> IO<A> {
	return catch(io)({ (let excn : Exception) in
		return handler(SomeException(excn.description ?? ""))
	})
}

// TODO: Masked exceptions?
public func mask<A, B>(io : (IO<A> -> IO<A>) -> IO<B>) -> IO<B> {
	return do_ {
		return io(id)
	}
}

public func onException<A, B>(io : IO<A>)(what : IO<B>) -> IO<A> {
	return catchException(io)({ e in
		return do_({
			let b : B = !what
			return throwIO(e)
		})
	})
}

public func bracket<A, B, C>(before : IO<A>)(after : A -> IO<B>)(thing : A -> IO<C>) -> IO<C> {
	return mask({ (let restore : IO<C> -> IO<C>) -> IO<C> in
		return do_ { () -> IO<C> in
			let a = !before
			let r = !onException(restore(thing(a)))(what: after(a))
			!after(a)
			return IO.pure(r)
		}	
	})
}

public func finally<A, B>(a : IO<A>)(then : IO<B>) -> IO<A> {
	return mask({ (let restore : IO<A> -> IO<A>) -> IO<A> in
		return do_ { () -> A in
			let r = !onException(restore(a))(what: then)
			let b = !then
			return r
		}
	})
}

public func try<A>(io : IO<A>) -> IO<Either<Exception, A>> {
	return catch(io >>- { v in IO.pure(Either.right(v)) })(h: { e in IO.pure(Either.left(e)) })
}

public func tryJust<A, B>(p : Exception -> Maybe<B>) -> IO<A> -> IO<Either<B, A>> {
	return { io in
		do_ {
			let r = !try(io)
			switch r.destruct() {
				case .Right(let bv):
					return IO.pure(Either.right(bv.unBox()))
				case .Left(let be):
					switch p(be.unBox()).destruct() {
						case .Nothing:
							return throwIO(be.unBox())
						case .Just(let b):
							return IO.pure(Either.left(b))
					}
			}
		}
	}
}

private func catch<A>(io : IO<A>)(h : (Exception -> IO<A>)) -> IO<A> {
	var val : A! 
	BASERealWorld.catch({ val = io.unsafePerformIO() }, to: { val = !h(SomeException($0.description ?? "")) })
	return IO.pure(val!)
}


