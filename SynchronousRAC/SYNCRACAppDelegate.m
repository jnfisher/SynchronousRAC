//
//  SYNCRACAppDelegate.m
//  SynchronousRAC
//
//  Created by John Fisher on 6/19/14.
//  Copyright (c) 2014 John Fisher. All rights reserved.
//

#import "SYNCRACAppDelegate.h"
#import "SYNCRACDevice.h"

@implementation SYNCRACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.deviceScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];

    NSLog(@"Main thread scheduling...");
    RACScheduler *mediatorScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
    [mediatorScheduler schedule:^{
        [self operationFive];
    }];

    [mediatorScheduler schedule:^{
        [self operationFour];
    }];

    [mediatorScheduler schedule:^{
        [self operationThree];
    }];

    [mediatorScheduler schedule:^{
        [self operationTwo];
    }];

    [mediatorScheduler schedule:^{
        [self operationOne];
    }];
    NSLog(@"Main thread scheduling complete.");


//    Another way, with NSOperationQueue, if we need to define explicit dependencies..
//
//    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationOne) object:nil];
//    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationTwo) object:nil];
//    NSInvocationOperation *operation3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationThree) object:nil];
//    NSInvocationOperation *operation4 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationFour) object:nil];
//    NSInvocationOperation *operation5 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationFive) object:nil];
//
//    NSOperationQueue *queue = [NSOperationQueue new];
//    queue.maxConcurrentOperationCount = 1;
//
//    [operation4 addDependency:operation1];
//
//    [queue addOperation:operation4];
//    [queue addOperation:operation5];
//    [queue addOperation:operation2];
//    [queue addOperation:operation3];
//    [queue addOperation:operation1];
//
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)operationOne {
    SYNCRACDevice  *device = [SYNCRACDevice new];
    NSLog(@"Operation 1 started... (successfull completion)");
    
    NSError *error = nil;
    [[[[device doSomethingAndTimeout:NO orError:NO name:@"Step One"] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Two"];
    }] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Three"];
    }]
    waitUntilCompleted:&error];
    
    if (error)  {
        NSLog(@"Operation failed %@!", [error localizedDescription]);
    }
    else {
        NSLog(@"Operation completed successfully.");
    }
    NSLog(@"\n");
}

- (void)operationTwo {
    SYNCRACDevice  *device = [SYNCRACDevice new];
    NSLog(@"Operation 2 started... (step two should error)");
    NSError *error = nil;
    [[[[device doSomethingAndTimeout:NO orError:NO name:@"Step One"] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:YES name:@"Step Two"];
    }] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Three"];
    }]
    waitUntilCompleted:&error];
    
    if (error)  {
        NSLog(@"Operation failed %@!", [error localizedDescription]);
    }
    else {
        NSLog(@"Operation completed successfully.");
    }
    NSLog(@"\n");
}

- (void)operationThree {
    SYNCRACDevice  *device = [SYNCRACDevice new];
    NSLog(@"Operation 3 started... (step one should error)");
    NSError *error = nil;
    [[[[device doSomethingAndTimeout:NO orError:YES name:@"Step One"] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:YES name:@"Step Two"];
    }] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Three"];
    }]
    waitUntilCompleted:&error];
    
    if (error)  {
        NSLog(@"Operation failed %@!", [error localizedDescription]);
    }
    else {
        NSLog(@"Operation completed successfully.");
    }
    NSLog(@"\n");
}

- (void)operationFour {
    SYNCRACDevice  *device = [SYNCRACDevice new];
    NSLog(@"Operation 4 started... (step two should time out)");
    NSError *error = nil;
    [[[[device doSomethingAndTimeout:NO orError:NO name:@"Step One"] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:YES orError:NO name:@"Step Two"];
    }] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Three"];
    }]
    waitUntilCompleted:&error];
    
    if (error)  {
        NSLog(@"Operation failed %@!", [error localizedDescription]);
    }
    else {
        NSLog(@"Operation completed successfully.");
    }
    NSLog(@"\n");
}

- (void)operationFive {
    SYNCRACDevice  *device = [SYNCRACDevice new];
    NSLog(@"Operation 5 started... (passes around stuff and succeeds)");
    NSError *error = nil;
    
    NSString *nextData = @"$$magical data$$";
    [[[[device doSomethingAndTimeout:NO orError:NO name:@"Step One" andSendNextObject:nextData] flattenMap:^RACStream *(id value) {
        NSLog(@"received some data: %@", value);
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Two"];
    }] flattenMap:^RACStream *(id value) {
        return [device doSomethingAndTimeout:NO orError:NO name:@"Step Three"];
    }]
    waitUntilCompleted:&error];
    
    if (error)  {
        NSLog(@"Operation failed %@!", [error localizedDescription]);
    }
    else {
        NSLog(@"Operation completed successfully.");
    }
    NSLog(@"\n");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
