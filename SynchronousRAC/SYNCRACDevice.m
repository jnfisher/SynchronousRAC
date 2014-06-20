//
//  SYNCRACDevice.m
//  SynchronousRAC
//
//  Created by John Fisher on 6/19/14.
//  Copyright (c) 2014 John Fisher. All rights reserved.
//

#import "SYNCRACDevice.h"
#import "SYNCRACAppDelegate.h"

@implementation SYNCRACDevice
- (void) delayWithName:(NSString *)name {
    // Do something that takes some time
    NSTimeInterval delay = arc4random_uniform(2) + arc4random_uniform(5) / 5.0;
    NSLog(@"%@ started, delaying %.3f seconds...", name, delay);
    [NSThread sleepForTimeInterval:delay];
}

- (RACSignal *)doSomethingAndTimeout:(BOOL)shouldTimeout orError:(BOOL)shouldError name:(NSString *)name {
    SYNCRACAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return [RACSignal startEagerlyWithScheduler:appDelegate.deviceScheduler block:^(id <RACSubscriber> subscriber) {
        [self delayWithName:name];
        
        if (shouldTimeout) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[NSString stringWithFormat:@"SYNCRACDevice %@ TIMED OUT!", name] forKey:NSLocalizedDescriptionKey];
            [subscriber sendError:[NSError errorWithDomain:@"SYNCRACDevice" code:2112 userInfo:details]];
        } else if (shouldError) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[NSString stringWithFormat:@"SYNCRACDevice %@ ERROR!", name] forKey:NSLocalizedDescriptionKey];
            [subscriber sendError:[NSError errorWithDomain:@"SYNCRACDevice" code:2112 userInfo:details]];
        } else {
            NSLog(@"%@ completed!", name);
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
    }];
}

- (RACSignal *)doSomethingAndTimeout:(BOOL)shouldTimeout orError:(BOOL)shouldError name:(NSString *)name andSendNextObject:(id)object {
    SYNCRACAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return [RACSignal startEagerlyWithScheduler:appDelegate.deviceScheduler block:^(id <RACSubscriber> subscriber) {
        [self delayWithName:name];
        
        if (shouldTimeout) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[NSString stringWithFormat:@"SYNCRACDevice %@ TIMED OUT!", name] forKey:NSLocalizedDescriptionKey];
            [subscriber sendError:[NSError errorWithDomain:@"SYNCRACDevice" code:2112 userInfo:details]];
        } else if (shouldError) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[NSString stringWithFormat:@"SYNCRACDevice %@ ERROR!", name] forKey:NSLocalizedDescriptionKey];
            [subscriber sendError:[NSError errorWithDomain:@"SYNCRACDevice" code:2112 userInfo:details]];
        } else {
            NSLog(@"%@ completed!", name);
            [subscriber sendNext:object];
            [subscriber sendCompleted];
        }
    }];
}
@end
