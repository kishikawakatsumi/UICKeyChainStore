//
//  UICKeyChainStoreTests.m
//  UICKeyChainStoreTests
//
//  Created by kishikawa katsumi on 2014/06/22.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UICKeyChainStore.h"

@interface UICKeyChainStoreTests : XCTestCase {
    NSString *kStubKey;
    NSString *kStubString;
    NSString *kStubService;
}

@end

@implementation UICKeyChainStoreTests

- (void)setUp
{
    [super setUp];
    
    kStubKey = @"password";
    kStubString = @"password1234";
    kStubService = @"com.kishikawakatsumi";
    
    [UICKeyChainStore removeAllItems];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetDefaultService
{
    NSString *serviceName = @"com.kishikawakatsumi.UICKeyChainStore";
    [UICKeyChainStore setDefaultService:serviceName];
    XCTAssertEqualObjects(serviceName, [UICKeyChainStore defaultService], @"specitfy default service name");
}

- (void)testInitializers
{
    UICKeyChainStore *store = nil;
    
    store = [UICKeyChainStore keyChainStore];
    XCTAssertEqualObjects(store.service, [UICKeyChainStore defaultService], @"instantiate default store");
    
    store = [[UICKeyChainStore alloc] init];
    XCTAssertEqualObjects(store.service, [UICKeyChainStore defaultService], @"instantiate default store");
    
    NSString *serviceName = @"com.kishikawakatsumi.UICKeyChainStore";
    store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    XCTAssertEqualObjects(store.service, serviceName, @"instantiate custom service named store");
}

- (void)testSetData
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey];
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"stored password");
    
    [UICKeyChainStore removeItemForKey:usernameKey service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
}

- (void)testSetUsernameAndPassword
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    
    [UICKeyChainStore setString:username forKey:usernameKey];
    [UICKeyChainStore setString:password forKey:passwordKey];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    
    [UICKeyChainStore removeItemForKey:usernameKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"left password");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey], @"removed password");
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
}

- (void)testSetSynchronize
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    
    NSString *serviceName = @"com.example.UICKeyChainStore";
    [UICKeyChainStore removeAllItemsForService:serviceName];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    [store removeAllItems];
    
    [store setString:username forKey:usernameKey];
    [store setString:password forKey:passwordKey];
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    
    [store synchronize];
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey service:serviceName], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"stored password");
    
    [store removeItemForKey:usernameKey];
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"left password");
    
    [store removeItemForKey:passwordKey];
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"removed password");
}

- (void)testClassMethodsSetAndRemoveItem
{
    // write to keychain
    [UICKeyChainStore setString:kStubString forKey:kStubKey];
    
    // read from keychain, test keychain contains item
    NSString *actualString = [UICKeyChainStore stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    // remove item from keychain
    [UICKeyChainStore removeItemForKey:kStubKey];
    
    // read from keychain, test keychain doesn't contain item
    actualString = [UICKeyChainStore stringForKey:kStubKey];
    expectedString = NULL;
    
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
}

- (void)testInstanceMethodsSetAndRemoveItem
{
    // create an instance
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    // write to keychain
    [store setString:kStubString forKey:kStubKey];
    [store synchronize];
    
    // read from keychain, test keychain contains item
    NSString *actualString = [store stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    // remove item from keychain
    [store removeItemForKey:kStubKey];
    [store synchronize];
    
    // read from keychain, test keychain doesn't contain item
    actualString = [store stringForKey:kStubKey];
    expectedString = NULL;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    actualString = [store description];
    expectedString = @"(\n)";
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
}


- (void)testObjectSubscripting
{
    // create an instance
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    
    NSString *expectedString = kStubString;
    
    // write to keychain using obj subscripting
    store[kStubKey] = kStubString;
    [store synchronize];
    
    // read from keychain using obj subscripting
    XCTAssertEqualObjects(store[kStubKey], kStubString, @"expected %@ but got %@", expectedString, store[kStubKey]);
}

@end
