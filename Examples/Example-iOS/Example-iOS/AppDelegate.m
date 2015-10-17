//
//  AppDelegate.m
//  Example-iOS
//
//  Created by kishikawa katsumi on 2015/01/15.
//  Copyright (c) 2015 kishikawa katsumi. All rights reserved.
//

#import "AppDelegate.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    keychainStore[@"password"] = @"abcd1234";
    
    return YES;
}

@end
