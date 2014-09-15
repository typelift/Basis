//
//  CFIRealWorld.h
//  Swift_Extras
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <pthread.h>

extern NSString *const CFIExceptionDomain;

@interface CFIRealWorld : NSObject

+ (void)raise:(NSString *)exception;
+ (void)catch:(void(^)(void))block to:(void(^)(NSException *))toBlock;

+ (pthread_t)forkWithStart:(void(^)(void))block;
+ (pthread_t)forkOnto:(unsigned int)processor withStart:(void(^)(void))block;

+ (void)labelThreadWithName:(const char *)name;
+ (void)yieldThread;

+ (void)killThread:(pthread_t)thread;

+ (NSUInteger)CPUCount;

@end
