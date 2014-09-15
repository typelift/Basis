//
//  STM.swift
//  Swift_Extras
//
//  Created by Robert Widmann on 9/15/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

import Foundation

public final class STM<A> : K1<A> {
	private let apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)
	
	init(apply: (rw: World<RealWorld>) -> (World<RealWorld>, A)) {
		self.apply = apply
	}
}

private func unSTM<A>(stm : STM<A>) -> (rw: World<RealWorld>) -> (World<RealWorld>, A) {
	return stm.apply
}

public func unsafeIOToSTM<A>(io : IO<A>) -> STM<A> {
	return STM(io.apply)
}
