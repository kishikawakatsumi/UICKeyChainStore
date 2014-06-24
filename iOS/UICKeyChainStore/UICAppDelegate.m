//
//  UICAppDelegate.m
//  UICKeyChainStore
//
//  Created by kishikawa katsumi on 2014/06/22.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

#import "UICAppDelegate.h"

@implementation UICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
