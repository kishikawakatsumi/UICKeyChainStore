//
//  UICKeyChainStoreTests.m
//  UICKeyChainStoreTests
//
//  Created by Steve Baker on 8/4/13.
//  Copyright (c) 2013 Beepscore LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UICKeyChainStore.h"

@interface UICKeyChainStoreTests : SenTestCase
{
    NSString *kStubKey;
    NSString *kStubService;
    NSString *kStubAccessGroup;
}
@end


@implementation UICKeyChainStoreTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.

    // Before running each test, remove item for key.
    kStubKey = @"stubKey";
    kStubService = @"stubService";
    kStubAccessGroup = @"stubAccessGroup";

    [UICKeyChainStore removeItemForKey:kStubKey
                               service:kStubService
                           accessGroup:kStubAccessGroup];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRemoveItemForKeyServiceAccessGroup
{
    BOOL actualResult = [UICKeyChainStore removeItemForKey:kStubKey
                                              service:kStubService
                                         accessGroup:kStubAccessGroup];
    BOOL expectedResult = YES;
    NSString *actualResultString = actualResult ? @"YES" : @"NO";
    NSString *expectedResultString = expectedResult ? @"YES" : @"NO";

    STAssertEquals(actualResult, expectedResult, @"setUp expected %@ but got %@",
                  expectedResultString, actualResultString);
}

@end
