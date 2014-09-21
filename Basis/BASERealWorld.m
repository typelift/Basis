//
//  BASERealWorld.m
//  Basis
//
//  Created by Robert Widmann on 9/13/14.
//  Copyright (c) 2014 Robert Widmann. All rights reserved.
//

#import "BASERealWorld.h"
#include <unistd.h>
#include <sys/errno.h>

#include <sched.h>
#include <mach/thread_act.h>
#include <mach/mach_host.h>

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

+ (pthread_t)forkWithStart:(void(^)(void))block {
	int r;
	pthread_t thrID;
	pthread_attr_t attr;
	
	pthread_attr_init (&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
		
	r = pthread_create(&thrID, &attr, CFIStartFork, (__bridge void *)(block));
	NSCAssert(r == 0, @"Could not fork thread.");
	return thrID;
}

+ (pthread_t)forkOnto:(unsigned int)processor withStart:(void (^)(void))block {
	NSInteger num_cores = sysconf(_SC_NPROCESSORS_ONLN);
	NSCAssert(processor >= num_cores, @"Could not fork thread.");

	pthread_t thrID = [BASERealWorld forkWithStart:block];

	thread_affinity_policy_data_t policy;
	policy.affinity_tag = processor;
	
	thread_policy_set(pthread_mach_thread_np(thrID), THREAD_AFFINITY_POLICY, (thread_policy_t)&policy, THREAD_AFFINITY_POLICY_COUNT);
	
	return thrID;
}

+ (void)labelThreadWithName:(const char *)name {
	pthread_setname_np(name);
}

+ (void)yieldThread {
	pthread_yield_np();
}

+ (void)killThread:(pthread_t)thread {
	pthread_cancel(thread);
}

+ (NSUInteger)CPUCount {
	uint64_t result = 1;
	struct host_basic_info info;
	mach_msg_type_number_t infocnt = 12;
	
	if (host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&info, &infocnt) == KERN_SUCCESS) {
		result = info.max_cpus;
	}
	return result;
}

void *CFIStartFork(void *context) {
	NSCAssert(context != NULL, @"Cannot execute NULL context block.");
	
	void (^block)(void) = (__bridge void (^)(void))(context);
	block();
	
	return NULL;
}

@end
