//
//  Lower.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

import Foundation

public postfix func ^<A, B>(f : Function<A, B>) -> A -> B {
	return { f.apply($0) }
}

public postfix func ^<A, B, C>(f : Function<A, Function<B, C>>) -> A -> B -> C {
	return { f.apply($0) |> { $0.apply } }

}

public postfix func ^<A, B, C, D>(f : Function<A, Function<B, Function<C, D>>>) -> A -> B -> C -> D {
	return { (let x) in
		return { (let y) in
			return { (let z) in 
				return f.apply(x).apply(y).apply(z)
			}
		}
	}
}

public postfix func ^<A, B, C, D, E>(f : Function<A, Function<B, Function<C, Function<D, E>>>>) -> A -> B -> C -> D -> E {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return f.apply(w).apply(x).apply(y).apply(z)
				}
			}
		}
	}
}

public postfix func ^<A, B, C, D, E, F>(f : Function<A, Function<B, Function<C, Function<D, Function<E, F>>>>>) -> A -> B -> C -> D -> E -> F {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return { (let a) in 
						return f.apply(w).apply(x).apply(y).apply(z).apply(a)
					}
				}
			}
		}
	}
}

public postfix func ^<A, B, C, D, E, F, G>(f : Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, G>>>>>>) -> A -> B -> C -> D -> E -> F -> G {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return { (let a) in 
						return { (let b) in 
							return f.apply(w).apply(x).apply(y).apply(z).apply(a).apply(b)
						}
					}
				}
			}
		}
	}
}

public postfix func ^<A, B, C, D, E, F, G, H>(f : Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, H>>>>>>>) -> A -> B -> C -> D -> E -> F -> G -> H {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return { (let a) in 
						return { (let b) in 
							return { (let c) in 
								return f.apply(w).apply(x).apply(y).apply(z).apply(a).apply(b).apply(c)
							}
						}
					}
				}
			}
		}
	}
}

public postfix func ^<A, B, C, D, E, F, G, H, I>(f : Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, Function<H, I>>>>>>>>) -> A -> B -> C -> D -> E -> F -> G -> H -> I {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return { (let a) in 
						return { (let b) in 
							return { (let c) in 
								return { (let d) in 
									return f.apply(w).apply(x).apply(y).apply(z).apply(a).apply(b).apply(c).apply(d)
								}
							}
						}
					}
				}
			}
		}
	}
}

public postfix func ^<A, B, C, D, E, F, G, H, I, J>(f : Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, Function<H, Function<I, J>>>>>>>>>) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> J {
	return { (let w) in
		return { (let x) in
			return { (let y) in
				return { (let z) in 
					return { (let a) in 
						return { (let b) in 
							return { (let c) in 
								return { (let d) in 
									return { (let e) in 
										return f.apply(w).apply(x).apply(y).apply(z).apply(a).apply(b).apply(c).apply(d).apply(e)
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

