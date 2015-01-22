//
//  BASERealWorld.h
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

extern NSString *const CFIExceptionDomain;

@interface BASERealWorld : NSObject

+ (void)catch:(void(^)(void))block to:(void(^)(NSException *))toBlock;
+ (void)throwException:(NSString *)description;

@end
