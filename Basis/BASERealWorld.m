//
//  BASERealWorld.m
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 TypeLift. All rights reserved.
//

#import "BASERealWorld.h"


NSString *const CFIExceptionDomain = @"CFIExceptionDomain";

@implementation BASERealWorld

+ (void)raise:(NSString *)exception {
	[NSException raise:CFIExceptionDomain format:@"%@", exception];
}

+ (void)catch:(void(^)(void))block to:(void(^)(NSException *))toBlock {
	@try {
		block();
	} @catch(NSException *e) {
		toBlock(e);
	}
}

@end
