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
    // to share keychain access between apps, access group must start with bundle seed id?
    //http://useyourloaf.com/blog/2010/04/03/keychain-group-access.html
    kStubAccessGroup = @"stubAccessGroup";

    [UICKeyChainStore removeAllItemsForService:kStubService
                                   accessGroup:kStubAccessGroup];
    [UICKeyChainStore removeAllItems];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testClassMethodsSetAndRemoveItem
{
    // write to keychain
    [UICKeyChainStore setString:kStubString forKey:kStubKey];

    // read from keychain, test keychain contains item
    NSString *actualString = [UICKeyChainStore stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    STAssertEqualObjects(expectedString, actualString,
                         @"expected %@ but got %@", expectedString, actualString);

    // remove item from keychain
    [UICKeyChainStore removeItemForKey:kStubKey];

    // read from keychain, test keychain doesn't contain item
    actualString = [UICKeyChainStore stringForKey:kStubKey];
    expectedString = NULL;

    STAssertEqualObjects(expectedString, actualString,
                         @"expected %@ but got %@", expectedString, actualString);
    
}

- (void)testInstanceMethodsSetAndRemoveItem
{
    // create an instance
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService
                                                             accessGroup:kStubAccessGroup];
    // write to keychain
    [store setString:kStubString forKey:kStubKey];
    [store synchronize];

    // read from keychain, test keychain contains item
    NSString *actualString = [store stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    STAssertEqualObjects(expectedString, actualString,
                         @"expected %@ but got %@", expectedString, actualString);

    // remove item from keychain
    [store removeItemForKey:kStubKey];
    [store synchronize];

    // read from keychain, test keychain doesn't contain item
    actualString = [store stringForKey:kStubKey];
    expectedString = NULL;
    STAssertEqualObjects(expectedString, actualString,
                         @"expected %@ but got %@", expectedString, actualString);

    actualString = [store description];
    expectedString = @"(\n)";
    STAssertEqualObjects(expectedString, actualString,
                         @"expected %@ but got %@", expectedString, actualString);
}

@end
