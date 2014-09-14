//
//  CFIExceptionImpl.m
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

#import "CFIExceptionImpl.h"

NSString *const CFIExceptionDomain = @"CFIExceptionDomain";

@implementation CFIExceptionImpl

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
