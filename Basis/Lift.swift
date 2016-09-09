//
//  Lift.swift
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

public prefix func ^ <A, B>(f : @escaping (A) -> B) -> Function<A, B> {
	return Function.arr(f)
}

public prefix func ^ <A, B, C>(f : @escaping (A) -> (B) -> C) -> Function<A, Function<B, C>> {
	return Function.arr({ x in
		return Function<B, C>.arr({ y in
			return f(x)(y)
		})
	})
}

public prefix func ^ <A, B, C, D>(f : @escaping (A) -> (B) -> (C) -> D) -> Function<A, Function<B, Function<C, D>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function<C, D>.arr({ y in
				return f(w)(x)(y)
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E>(f : @escaping (A) -> (B) -> (C) -> (D) -> E) -> Function<A, Function<B, Function<C, Function<D, E>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function<D, E>.arr({ z in
					return f(w)(x)(y)(z)
				})
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E, F>(f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> F) -> Function<A, Function<B, Function<C, Function<D, Function<E, F>>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function.arr({ z in
					return Function<E, F>.arr({ a in
						return f(w)(x)(y)(z)(a)
					})
				})
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E, F, G>(f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G) -> Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, G>>>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function.arr({ z in
					return Function.arr({ a in
						return Function<F, G>.arr({ b in
							return f(w)(x)(y)(z)(a)(b)
						})
					})
				})
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E, F, G, H>(f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H) -> Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, H>>>>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function.arr({ z in
					return Function.arr({ a in
						return Function.arr({ b in
							return Function<G, H>.arr({ c in
								return f(w)(x)(y)(z)(a)(b)(c)
							})
						})
					})
				})
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E, F, G, H, I>(f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I) -> Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, Function<H, I>>>>>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function.arr({ z in
					return Function.arr({ a in
						return Function.arr({ b in
							return Function.arr({ c in
								return Function<H, I>.arr({ d in
									return f(w)(x)(y)(z)(a)(b)(c)(d)
								})
							})
						})
					})
				})
			})
		})
	})
}

public prefix func ^ <A, B, C, D, E, F, G, H, I, J>(f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J) -> Function<A, Function<B, Function<C, Function<D, Function<E, Function<F, Function<G, Function<H, Function<I, J>>>>>>>>> {
	return Function.arr({ w in
		return Function.arr({ x in
			return Function.arr({ y in
				return Function.arr({ z in
					return Function.arr({ a in
						return Function.arr({ b in
							return Function.arr({ c in
								return Function.arr({ d in
									return Function<I, J>.arr({ e in
										return f(w)(x)(y)(z)(a)(b)(c)(d)(e)
									})
								})
							})
						})
					})
				})
			})
		})
	})
}


