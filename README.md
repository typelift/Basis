[![Build Status](https://travis-ci.org/typelift/Basis.svg?branch=master)](https://travis-ci.org/typelift/Basis)

Basis
=====

The Basis is an exploration of pure declarative programming and reasoning in 
Swift.  It by no means contains idiomatic code, but is instead intended to be a
repository for structures and ideas grounded in theory and mathematics.  Present
in this repository are the necessary components to handle system interaction, 
control, data flow, and a number of extensions and improvements to the Swift 
Standard Library and its structures.  Higher-level APIs and structures are 
generally excluded from the Basis to be implemented in other libraries.
 

It Gets Better!
===============

Swift provides an excellent opportunity to not just witness, but actually 
understand the formalization of many seemingly "complex" and abstract algebraic
structures without having to learn Haskell or ML or any of the other famous FP 
languages.  The documentation of types in this repository serves as a way to 
de-serialize a lot of the complex terms and jargon you may come across in these 
languages.  If, for any reason, the documentation is too dense or unreadable, it
means this library is failing one of its unit tests!  Clarification or rewrites
of documentation to serve the broader community are a priority and a promise.  
Any questions or comments should be made into issues, or pull requests if you 
feel you can word it better.

Let's make the world a bit less scary.

Getting Started
===============

Basis comes wrapped up as a framework and iOS and OS X.  Simply add the project
as a submodule, drag it to your project's file tree, and add it as a framework 
dependency for your build.  When all is said and done, just 

```
import Basis
``` 

Introduction
============

Because The Basis places emphasis on functions over structures, the majority of
the functions in this repository are free and combinatorial.  Programming with
them then becomes a matter of selecting the proper combinators and compositional
operators to achieve a desired type signature.

To take a famous example from Haskell:

```Swift
/// Sorts a list by recursively partitioning its elements into sublists around a
/// pivot element.
func quickSort<T : Comparable>(l : [T]) -> [T] {
    switch destruct(l) {
        case .Empty:
            return []
        case let .Cons(x, xs):
            let lesser  = xs.filter({ $0 < x })
            let greater = xs.filter({ $0 >= x })
            return quickSort(lesser) + [x] + quickSort(greater)
    }
}
```

Or perhaps a more convoluted example:

```Swift
/// Lift any 1-ary function to a function over Maybes.
func liftA<A, B>(f : A -> B) -> Maybe<A> -> Maybe<B> {
    return { a in Maybe.pure(f) <*> a }
}

/// Lift any 2-ary function to a function over 2 Maybes.   
func liftA2<A, B, C>(f : A -> B -> C) -> Maybe<A> -> Maybe<B> -> Maybe<C> {
    return { a in { b in Maybe.pure(f) <*> a <*> b } }
}

/// Lift any 3-ary function to a function over 3 Maybes.
func liftA3<A, B, C, D>(f : A -> B -> C -> D) -> Maybe<A> -> Maybe<B> -> Maybe<C> -> Maybe <D> {
    return { a in { b in { c in Maybe.pure(f) <*> a <*> b <*> c } } }
}
```

With such an architecture in place, we can replace the classic `if-let` pattern
for optionals with calls to liftA2:

```Swift
let a = Maybe.just(6)
let b = Maybe<Int>.nothing()
let c = Maybe.just(5)

/// The result of adding 6 to Nothing is Nothing.
let nothing = liftA2(curry(+))(a)(b)

/// The result of adding 5 and 6 is 11
let something = liftA2(curry(+))(a)(c)

/// The result of packing 6, 5, and Nothing into a tuple is Nothing.
let noTupleHere = liftA3(pack3)(a)(b)(c)
```

We can also exploit the tools Swift has given us for laziness and use them to
build up infinite data structures despite having only a finite amount of memory.

```Swift
/// Returns a stream of every Natural Number.  Because Streams are built up 
/// iteratively only on demand, we needn't load every element at once, 
/// just one at a time as they are requested. 
///
/// arr[0] == 0, arr[1] == 1, arr[2] == 2, ..., arr[n] == n
let naturalNumbers = iterate({ 1 + $0 })(0)

/// Returns a stream consisting of only the items in a given list.
///
/// arr[0] == "You", arr[1] == "Say", arr[2] == "Goodbye", arr[4] == "You", ...
let butISayHello = cycle(["You", "Say", "Goodbye"])
```

Or even use laziness to help with control flow.

```Swift
/// A version of the factorial function that, while appearing recursive,
/// actually evaluates in a constant amount of stack space.  As such it will
/// never smash the stack no matter how large an input it is given. 
func noSmashFactorial(x : Double, _ acc : Double = 1.0) -> Trampoline<Double> {
    if x <= 1 {
        return now(acc)
    }
    return later(noSmashFac(x - 1, acc * x))
}

/// The result of invoking this function is about 10^10^5.328.  Obviously, such
/// a number is completely unrepresentable in any bitwidth Swift gives us.  The 
/// thing to notice is that we would have pushed 50,000 frames onto the stack.  
/// Instead we push just 1. 
let inf = noSmashFactorial(50000).run()
```

We're no strangers to the Real World either.  Swift is a profoundly imperative
language at heart, but that doesn't mean we can't do something about it.  Enter
the IO Monad.  Our IO Monad is the incarnation of an effect that has yet to
happen.

```Swift
/// An effect that, when executed, will pause for input from the terminal, then
/// shout it back at you.
let eff = interact(pack • map({ $0.toUpper() }) • unpack)
/// ...
/// Executes the effect with the current state of the world.
eff.unsafePerformIO()
```

System Requirements
===================

The Basis supports OS X 10.9+ and iOS 7.0+

License
=======

The Basis is released under the MIT license.

Further Reading
===============

- [SML](http://en.wikipedia.org/wiki/Standard_ML)
- [Haskell](http://haskell.org/)
- [TTFP](https://www.cs.kent.ac.uk/people/staff/sjt/TTFP/)
