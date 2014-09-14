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

public func |*|<A, B, C>(o : (B, B) -> C, f : A -> B) -> A -> A -> C {
	return on(o)(f)
}

public func on<A, B, C>(o : B -> B -> C)(f : A -> B) -> A -> A -> C {
	return { (let x) in
		return {(let y) in 
			return o(f(x))(f(y))
		}
	}
}

public func on<A, B, C>(o : (B, B) -> C)(f : A -> B) -> A -> A -> C {
	return { (let x) in
		return {(let y) in 
			return o(f(x), f(y))
		}
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

