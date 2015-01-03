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
    
    [UICKeyChainStore setDefaultService:kStubService];
    
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

- (void)testSetDefaultAccessibility
{
    CFTypeRef accessibility = kSecAttrAccessibleAlwaysThisDeviceOnly;
    [UICKeyChainStore setDefaultAccessibility:accessibility];
    XCTAssertEqualObjects((__bridge id)accessibility, [UICKeyChainStore defaultAccessibility], "@specify default accessibility");
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
    
    CFTypeRef accessibility = kSecAttrAccessibleAlwaysThisDeviceOnly;
    store = [UICKeyChainStore keyChainStoreWithAccessibility:accessibility];
    XCTAssertEqualObjects(store.accessibility, (__bridge id)accessibility, "@instantiate custom store with accessibility specified");
    
    store = [UICKeyChainStore keyChainStoreWithService:serviceName accessibility:accessibility];
    XCTAssertEqualObjects(store.service, serviceName, "@instantiate custom service named store (with accessibility specified)");
    XCTAssertEqualObjects(store.accessibility, (__bridge id)accessibility,
                          @"instantiate custom store with accessibility specified (and named service");
}

- (void)testSetData
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *deviceData = [device dataUsingEncoding:NSUTF8StringEncoding];
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey];
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey];
    [UICKeyChainStore setData:deviceData forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], deviceData, "@stored device");
    
    [UICKeyChainStore removeItemForKey:usernameKey service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");

    [UICKeyChainStore removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility]);
}

- (void)testSetDataWithNoError
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *deviceData = [device dataUsingEncoding:NSUTF8StringEncoding];
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    NSError *error;
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey error:&error], usernameData, @"stored username");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey error:&error], passwordData, @"stored password");
    XCTAssertNil(error, @"no error");

    [UICKeyChainStore setData:deviceData forKey:deviceKey accessibility:accessibility error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility error:&error], deviceData, "@stored device");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:usernameKey service:[UICKeyChainStore defaultService] error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey error:&error], passwordData, @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:passwordKey service:[UICKeyChainStore defaultService] error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey error:&error], @"removed password");
    XCTAssertNil(error, @"no error");

    [UICKeyChainStore removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility]);
}

- (void)testSetNilData
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *deviceData = [device dataUsingEncoding:NSUTF8StringEncoding];
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    [UICKeyChainStore setData:nil forKey:usernameKey];
    [UICKeyChainStore setData:nil forKey:passwordKey];
    [UICKeyChainStore setData:nil forKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"no password");
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], @"no device");
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey];
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey];
    [UICKeyChainStore setData:[device dataUsingEncoding:NSUTF8StringEncoding] forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], deviceData, @"stored device");
    
    [UICKeyChainStore setData:nil forKey:usernameKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"left password");
    
    [UICKeyChainStore setData:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");

    [UICKeyChainStore setData:nil forKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], @"removed device");
    
    [UICKeyChainStore removeItemForKey:usernameKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
    
    [UICKeyChainStore removeItemForKey:passwordKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
    
    [UICKeyChainStore removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], @"removed device");
}

- (void)testSetUsernameAndPassword
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    [store removeAllItemsWithAccessibility:accessibility];
    
    [UICKeyChainStore setString:username forKey:usernameKey];
    [UICKeyChainStore setString:password forKey:passwordKey];
    [UICKeyChainStore setString:device forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility], device, @"stored device");
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility], device, @"stored device");
    
    [UICKeyChainStore removeItemForKey:usernameKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"left password");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    
    [UICKeyChainStore removeItemForKey:passwordKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey], @"removed password");
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");

    [UICKeyChainStore removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility], @"removed device");
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility], @"removed device");
}

- (void)testSetUsernameAndPasswordWithNoError
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    NSError *error;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItemsWithError:&error];
    XCTAssertNil(error, @"no error");
    [store removeAllItemsWithAccessibility:accessibility error:&error];
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setString:username forKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setString:password forKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setString:device forKey:deviceKey accessibility:accessibility error:&error];
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility error:&error], device, @"stored device");
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([store stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility error:&error], device, @"stored device");
    XCTAssertNil(error, @"no error");

    [UICKeyChainStore removeItemForKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey error:&error], password, @"left password");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:passwordKey error:&error], @"removed password");
    XCTAssertNil(error, @"no error");

    [UICKeyChainStore removeItemForKey:deviceKey accessibility:accessibility error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility error:&error], @"removed device");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility error:&error], @"removed device");
    XCTAssertNil(error, @"no error");
}

- (void)testSetNilUsernameAndNilPassword
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    [store removeAllItemsWithAccessibility:accessibility];
    
    [UICKeyChainStore setString:nil forKey:usernameKey];
    [UICKeyChainStore setString:nil forKey:passwordKey];
    [UICKeyChainStore setString:nil forKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"no password");
    XCTAssertNil([UICKeyChainStore dataForKey:deviceKey accessibility:accessibility], @"no device");
    
    [UICKeyChainStore setString:username forKey:usernameKey];
    [UICKeyChainStore setString:password forKey:passwordKey];
    [UICKeyChainStore setString:device forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility], device, @"stored device");
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility], device, @"stored device");
    
    [UICKeyChainStore setString:nil forKey:usernameKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"left password");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    
    [UICKeyChainStore setString:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey], @"removed password");
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");

    [UICKeyChainStore setString:nil forKey:deviceKey accessibility:accessibility];
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey accessibility:accessibility], @"removed device");
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility], @"removed device");
}

- (void)testSynchronize1
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
   
    NSString *serviceName = @"com.example.UICKeyChainStore";
    [UICKeyChainStore removeAllItemsForService:serviceName];

    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    [UICKeyChainStore removeAllItemsForService:serviceName accessibility:accessibility];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    [store removeAllItems];
    [store removeAllItemsWithAccessibility:accessibility];
    
    [store setString:username forKey:usernameKey];
    [store setString:password forKey:passwordKey];
    [store setString:device forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility], device, @"stored device");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"not synchronized yet");
    
    [store synchronize];
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility], device, @"stored device");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey service:serviceName], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"stored password");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], device, @"stored device");
    
    [store removeItemForKey:usernameKey];
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName], password, @"left password");
    
    [store removeItemForKey:passwordKey];
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"removed password");
    
    [store removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility], @"removed device");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"removed device");
}

- (void)testSynchronize2
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *deviceKey = @"device";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSString *device = @"deviceID";
    
    NSString *serviceName = @"com.example.UICKeyChainStore";
    [UICKeyChainStore removeAllItemsForService:serviceName];
    
    CFTypeRef accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    [UICKeyChainStore removeAllItemsForService:serviceName accessibility:accessibility];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    [store removeAllItems];
    [store removeAllItemsWithAccessibility:accessibility];
    
    [store setString:username forKey:usernameKey];
    [store setString:password forKey:passwordKey];
    [store setString:device forKey:deviceKey accessibility:accessibility];
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:deviceKey accessbility:accessibility], device, @"stored device");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"not synchronized yet");
    
    [store removeItemForKey:usernameKey];
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"not synchronized yet");
    
    [store removeItemForKey:passwordKey];
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"not synchronized yet");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"not synchronized yet");

    [store removeItemForKey:deviceKey accessibility:accessibility];
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility], @"removed device");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"not synchronized yet");
    
    [store synchronize];
    
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
    XCTAssertNil([store stringForKey:deviceKey accessbility:accessibility], @"removed device");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName], @"removed password");
    XCTAssertNil([UICKeyChainStore stringForKey:deviceKey service:serviceName accessibility:accessibility], @"removed device");
}

- (void)testSynchronizeWithNoError
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    
    NSString *serviceName = @"com.example.UICKeyChainStore";
    
    NSError *error;
    
    [UICKeyChainStore removeAllItemsForService:serviceName error:&error];
    XCTAssertNil(error, @"no error");
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:serviceName];
    [store removeAllItemsWithError:&error];
    XCTAssertNil(error, @"no error");
    
    [store setString:username forKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    [store setString:password forKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName error:&error], @"not synchronized yet");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName error:&error], @"not synchronized yet");
    XCTAssertNil(error, @"no error");
    
    [store synchronizeWithError:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey service:serviceName error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    
    [store removeItemForKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:usernameKey error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"left password");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey service:serviceName error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey service:serviceName error:&error], password, @"left password");
    XCTAssertNil(error, @"no error");
    
    [store removeItemForKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:passwordKey error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey service:serviceName error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
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

- (void)testClassMethodsSetAndRemoveItemWithNoError
{
    NSError *error;
    
    [UICKeyChainStore setString:kStubString forKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    
    NSString *actualString = [UICKeyChainStore stringForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    NSString *expectedString = kStubString;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    // remove item from keychain
    [UICKeyChainStore removeItemForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    
    // read from keychain, test keychain doesn't contain item
    actualString = [UICKeyChainStore stringForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
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

- (void)testInstanceMethodsSetAndRemoveItemWithNoError
{
    NSError *error;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    
    [store setString:kStubString forKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    [store synchronizeWithError:&error];
    XCTAssertNil(error, @"no error");
    
    NSString *actualString = [store stringForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    NSString *expectedString = kStubString;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    [store removeItemForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    [store synchronizeWithError:&error];
    XCTAssertNil(error, @"no error");
    
    actualString = [store stringForKey:kStubKey error:&error];
    XCTAssertNil(error, @"no error");
    expectedString = NULL;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    actualString = [store description];
    expectedString = @"(\n)";
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
}

- (void)testInstanceMethodsSetAndRemoveWithNilValue
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    
    [store setString:kStubString forKey:kStubKey];
    [store synchronize];
    
    NSString *actualString = [store stringForKey:kStubKey];
    NSString *expectedString = kStubString;
    XCTAssertEqualObjects(expectedString, actualString,
                          @"expected %@ but got %@", expectedString, actualString);
    
    [store setString:nil forKey:kStubKey];
    [store synchronize];
    
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
    
    // write to keychain using obj subscripting
    store[kStubKey] = kStubString;
    [store synchronize];
    
    NSString *actualString = store[kStubKey];
    NSString *expectedString = kStubString;
    
    // read from keychain using obj subscripting
    XCTAssertEqualObjects(expectedString, actualString, @"expected %@ but got %@", expectedString, actualString);
    
    store[kStubKey] = nil;
    [store synchronize];
    
    actualString = store[kStubKey];
    expectedString = NULL;
    
    XCTAssertEqualObjects(expectedString, actualString, @"expected %@ but got %@", expectedString, actualString);
}

@end
