//
//  UICKeyChainStoreTests.m
//  UICKeyChainStoreTests
//
//  Created by Steve Baker on 8/4/13.
//  Copyright (c) 2013 Beepscore LLC. All rights reserved.
//  MIT License
//

#import "UICKeyChainStoreTests.h"
#import "UICKeyChainStore.h"

@interface UICKeyChainStoreTests () {
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
    [super tearDown];
}

- (void)testSetDefaultService
{
    NSString *serviceName = @"com.kishikawakatsumi.UICKeyChainStore";
    [UICKeyChainStore setDefaultService:serviceName];
    STAssertEqualObjects(serviceName, [UICKeyChainStore defaultService], @"specitfy default service name");
}

- (void)testInitializers
{
    UICKeyChainStore *store = nil;
    
    store = [UICKeyChainStore keyChainStore];
    STAssertEqualObjects(store.service, [UICKeyChainStore defaultService], @"instantiate default store");
    
    store = [[UICKeyChainStore alloc] init];
    STAssertEqualObjects(store.service, [UICKeyChainStore defaultService], @"instantiate default store");
    
    NSString *serviceName = @"com.kishikawakatsumi.UICKeyChainStore";
    store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    STAssertEqualObjects(store.service, serviceName, @"instantiate custom service named store");
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
    
    STAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey], usernameData, @"stored username");
    STAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"stored password");
    
    [UICKeyChainStore removeItemForKey:usernameKey service:[UICKeyChainStore defaultService]];
    STAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    STAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey service:[UICKeyChainStore defaultService]];
    STAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    STAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
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
    
    STAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey], username, @"stored username");
    STAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"stored password");
    STAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    STAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    
    [UICKeyChainStore removeItemForKey:usernameKey];
    STAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    STAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"left password");
    STAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey];
    STAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    STAssertNil([UICKeyChainStore stringForKey:passwordKey], @"removed password");
    STAssertNil([store stringForKey:usernameKey], @"removed username");
    STAssertNil([store stringForKey:passwordKey], @"removed password");
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
    
    STAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    STAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    STAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"not synchronized yet");
    STAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    
    [store synchronize];
    STAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    STAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    STAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey service:serviceName], username, @"stored username");
    STAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"stored password");
    
    [store removeItemForKey:usernameKey];
    STAssertNil([store stringForKey:usernameKey], @"removed username");
    STAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    STAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"removed username");
    STAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"left password");
    
    [store removeItemForKey:passwordKey];
    STAssertNil([store stringForKey:passwordKey], @"removed password");
    STAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"removed password");
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


- (void)testObjectSubscripting
{
    // create an instance
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService
                                                             accessGroup:kStubAccessGroup];
    
    NSString *expectedString = kStubString;
    
    // write to keychain using obj subscripting
    store[kStubKey] = kStubString;
    [store synchronize];
    
    // read from keychain using obj subscripting
    STAssertEqualObjects(store[kStubKey], kStubString, @"expected %@ but got %@", expectedString, store[kStubKey]);
    
}

@end
