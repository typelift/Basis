//
//  Bounded.swift
//  Basis
//
//  Created by Robert Widmann on 9/7/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

import Darwin

/// Bounded types are types that have definable upper and lower limits.  For types like the Int and
/// Float, their limits are the minimum and maximum possible values representable in their bit-
/// width.  While the definition of a "limit" is flexible, generally custom types that wish to
/// appear bounded must come with some kind of supremum and infimum.
public protocol Bounded {
	/// The minimum value of a Bounded type.
	static var minBound : Self { get }

	/// The maximum value of a Bounded type.
	static var maxBound : Self { get }
}

extension Bool : Bounded {
	public static var minBound : Bool {
		return false
	}
	
	public static var maxBound : Bool {
		return true
	}
}

extension Character : Bounded {
	public static var minBound : Character {
		return "\0"
	}
	
	public static var maxBound : Character {
		return "\u{FFFFF}"
	}
}

extension UInt : Bounded {
	public static var minBound : UInt {
		return UInt.min
	}
	
	public static var maxBound : UInt {
		return UInt.max
	}
}

extension UInt8 : Bounded {
	public static var minBound : UInt8 {
		return UInt8.min
	}
	
	public static var maxBound : UInt8 {
		return UInt8.max
	}
}

extension UInt16 : Bounded {
	public static var minBound : UInt16 {
		return UInt16.min
	}
	
	public static var maxBound : UInt16 {
		return UInt16.max
	}
}


extension UInt32 : Bounded {
	public static var minBound : UInt32 {
		return UInt32.min
	}
	
	public static var maxBound : UInt32 {
		return UInt32.max
	}
}


extension UInt64 : Bounded {
	public static var minBound : UInt64 {
		return UInt64.min
	}
	
	public static var maxBound : UInt64 {
		return UInt64.max
	}
}

extension Int : Bounded {
	public static var minBound : Int {
		return Int.min
	}
	
	public static var maxBound : Int {
		return Int.max
	}
}

extension Int8 : Bounded {
	public static var minBound : Int8 {
		return Int8.min
	}
	
	public static var maxBound : Int8 {
		return Int8.max
	}
}

extension Int16 : Bounded {
	public static var minBound : Int16 {
		return Int16.min
	}
	
	public static var maxBound : Int16 {
		return Int16.max
	}
}


extension Int32 : Bounded {
	public static var minBound : Int32 {
		return Int32.min
	}
	
	public static var maxBound : Int32 {
		return Int32.max
	}
}


extension Int64 : Bounded {
	public static var minBound : Int64 {
		return Int64.min
	}
	
	public static var maxBound : Int64 {
		return Int64.max
	}
}

extension Float : Bounded {
	public static var minBound : Float {
		return FLT_MIN
	}
	
	public static var maxBound : Float {
		return FLT_MAX
	}
}

extension Double : Bounded {
	public static var minBound : Double {
		return DBL_MIN
	}
	
	public static var maxBound : Double {
		return DBL_MAX
	}
}

/// float.h does not export Float80's limits, nor does the Swift STL.
// rdar://18404510
//extension Swift.Float80 : Bounded {
//	public static var minBound : Swift.Float80 {
//		return LDBL_MIN
//	}
//
//	public static var maxBound : Swift.Float80 {
//		return LDBL_MAX
//	}
//}
