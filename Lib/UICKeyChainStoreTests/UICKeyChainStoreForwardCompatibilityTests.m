//
//  UICKeyChainStoreForwardCompatibilityTests.m
//  UICKeyChainStore
//
//  Created by goro-fuji on 2/17/15.
//  Copyright (c) 2015 kishikawa katsumi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UICKeyChainStore.h"
#import "UICv1KeyChainStore.h"

@interface UICKeyChainStoreForwardCompatibilityTests : XCTestCase

@end

@implementation UICKeyChainStoreForwardCompatibilityTests

- (void)setUp
{
    [super setUp];

    [UICKeyChainStore setDefaultService:@(__FILE__)];
    [UICv1KeyChainStore setDefaultService:@(__FILE__)];

    [UICKeyChainStore removeAllItems];
}

- (void)tearDown
{
    [UICKeyChainStore removeAllItems];

    [super tearDown];
}

- (void)testReadV1DataFromV2
{
    [UICv1KeyChainStore setString:@"http://example.com/" forKey:@"url"];

    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"url"], @"http://example.com/");
}

- (void)testReadV2DataFromV1
{
    [UICKeyChainStore setString:@"http://example.com/" forKey:@"url" genericAttribute:@"url"];

    XCTAssertEqualObjects([UICv1KeyChainStore stringForKey:@"url"], @"http://example.com/");
}

@end
