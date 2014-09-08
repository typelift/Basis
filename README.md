Swift-Extras
============

Swift-Extras functions in much the same way that Haskell's infamous basic-prelude package does, but the two are spiritually quite different.  While the basic-prelude package aims to provide just that, a basic prelude on which to build others, Swift-Extras focuses on bringing Haskell's prelude to Swift.

Swift's standard libraries are insufficiently general and unnecessarily complicated by webs of associated types and protocols.  There is far too much emphasis placed on objects, and far too little placed on functions and composition.  Swift-Extras remedies this by exporting a number of desirable missing features (currying, function composition, and an IO monad among others) to force the STL into the modern age.  This library provides the basic outline and core types for an application that wishes to appear functional in more than just name only.

Getting Started
===============

Swift-Extras comes wrapped up as a framework and iOS and OS X.  Simply add the project as a submodule, drag it to your project's file tree, and add it as a framework dependency for your build.  When all is said and done, just 

```
import Swift_Extras
``` 

and you're golden.

License
=======

`Swift-Extras` is licensed under the [MIT](http://opensource.org/licenses/MIT) license. See the [LICENSE](LICENSE) file for more.

