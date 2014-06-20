//
//  SYNCRACDevice.h
//  SynchronousRAC
//
//  Created by John Fisher on 6/19/14.
//  Copyright (c) 2014 John Fisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface SYNCRACDevice : NSObject
- (RACSignal *)doSomethingAndTimeout:(BOOL)shouldTimeout orError:(BOOL)shouldError name:(NSString *)name;
- (RACSignal *)doSomethingAndTimeout:(BOOL)shouldTimeout orError:(BOOL)shouldError name:(NSString *)name andSendNextObject:(id)object;
@end
