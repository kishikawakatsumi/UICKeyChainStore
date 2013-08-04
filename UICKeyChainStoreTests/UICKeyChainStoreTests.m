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
    NSString *kStubString;
    NSString *kStubService;
    NSString *kStubAccessGroup;
}
@end


@implementation UICKeyChainStoreTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.

    // Before running each test, remove items from keychain 
    kStubKey = @"password";
    kStubString = @"password1234";
    kStubService = @"com.kishikawakatsumi";
    kStubAccessGroup = @"stubAccessGroup";

    [UICKeyChainStore removeAllItemsForService:kStubService
                                   accessGroup:kStubAccessGroup];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSetStringForKey
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService
                                                             accessGroup:kStubAccessGroup];
    // write to keychain
    [store setString:kStubString forKey:kStubKey];

    // read result from keychain
    NSString *actualResult = [store stringForKey:kStubKey];
    
    NSString *expectedResult = kStubString;

    STAssertEqualObjects(expectedResult, actualResult, @"expected %@ but got %@",
                  expectedResult, actualResult);
}

- (void)testRemoveAllItemsForServiceAccessGroup
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService
                                                             accessGroup:kStubAccessGroup];
    // write to keychain
    [store setString:kStubString forKey:kStubKey];

    // read from keychain, test keychain contains item
    NSString *actualString = [store stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    STAssertEqualObjects(expectedString, actualString, @"expected %@ but got %@",
                  expectedString, actualString);

    // remove items from keychain
    BOOL actualResult = [UICKeyChainStore removeAllItemsForService:kStubService
                                                       accessGroup:kStubAccessGroup];
    // test remove succeeded
    BOOL expectedResult = YES;
    NSString *actualResultString = actualResult ? @"YES" : @"NO";
    NSString *expectedResultString = expectedResult ? @"YES" : @"NO";

    STAssertEquals(expectedResult, actualResult, @"expected %@ but got %@",
                  expectedResultString, actualResultString);

    // read from keychain, test keychain doesn't contain item
    actualString = [UICKeyChainStore stringForKey:kStubKey
                                                  service:kStubService
                                              accessGroup:kStubAccessGroup];
    expectedString = NULL;
    
    STAssertEqualObjects(expectedString, actualString, @"expected %@ but got %@",
                  expectedString, actualString);
}

@end
