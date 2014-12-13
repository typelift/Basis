[![Build Status](https://travis-ci.org/typelift/Basis.svg?branch=master)](https://travis-ci.org/typelift/Basis)

Basis
=====

The Basis is an exploration of pure declarative programming and reasoning in Swift.  It by no means contains idiomatic code, but is instead intended to be a repository for structures and ideas grounded in theory and mathematics.  Present in this repository are the necessary components to handle system interaction, control, data flow, and a number of extensions and improvements to the Swift Standard Library and its structures.  Higher-level APIs and structures are generally excluded from the Basis to be implemented in other libraries.
 

It Gets Better!
===============

Swift provides an excellent opportunity to not just witness, but actually understand, the formalization of many seemingly "complex" and abstract algebraic structures without having to learn Haskell or ML or any of the other famous FP languages.  The documentation of types in this repository serves as a way to de-serialize a lot of the complex terms and jargon you may come across in these languages.  If, for any reason, the documentation is too dense or unreadable, it means this library is failing one of its unit tests!  Clarification or rewrites of documentation to serve the broader community are a priority and a promise.  Any questions or comments should be made into issues, or pull requests if you feel you can word it better.

Let's make the world a bit less scary.

Getting Started
===============

Basis comes wrapped up as a framework and iOS and OS X.  Simply add the project as a submodule, drag it to your project's file tree, and add it as a framework dependency for your build.  When all is said and done, just 

```
import Basis
``` 