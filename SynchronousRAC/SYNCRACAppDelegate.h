//
//  SYNCRACAppDelegate.h
//  SynchronousRAC
//
//  Created by John Fisher on 6/19/14.
//  Copyright (c) 2014 John Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@interface SYNCRACAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RACScheduler *deviceScheduler;
@end
