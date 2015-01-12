//
//  UICKeyChainStoreTests.m
//  UICKeyChainStoreTests
//
//  Created by kishikawa katsumi on 2014/06/22.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UICKeyChainStore.h"

@interface UICKeyChainStoreTests : XCTestCase

@end

@implementation UICKeyChainStoreTests

- (void)setUp
{
    [super setUp];
    
    [UICKeyChainStore setDefaultService:@""];
    
    [UICKeyChainStore removeAllItems];
    
    [[UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"] removeAllItems];
    [[UICKeyChainStore keyChainStoreWithService:@"Twitter"] removeAllItems];
    
    [[UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://example.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS] removeAllItems];
    
    [[UICKeyChainStore keyChainStore] removeAllItems];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark -

- (void)testGenericPassword
{
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        [keychain setString:@"kishikawa_katsumi" forKey:@"username"];
        [keychain setString:@"password_1234" forKey:@"password"];
        
        NSString *username = [keychain stringForKey:@"username"];
        XCTAssertEqualObjects(username, @"kishikawa_katsumi");
        
        NSString *password = [keychain stringForKey:@"password"];
        XCTAssertEqualObjects(password, @"password_1234");
    }
    
    {
        // Update Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        [keychain setString:@"katsumi_kishikawa" forKey:@"username"];
        [keychain setString:@"1234_password" forKey:@"password"];
        
        NSString *username = [keychain stringForKey:@"username"];
        XCTAssertEqualObjects(username, @"katsumi_kishikawa");
        
        NSString *password = [keychain stringForKey:@"password"];
        XCTAssertEqualObjects(password, @"1234_password");
    }
    
    {
        // Remove Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        [keychain removeItemForKey:@"username"];
        [keychain removeItemForKey:@"password"];
        
        XCTAssertNil([keychain stringForKey:@"username"]);
        XCTAssertNil([keychain stringForKey:@"password"]);
    }
}

- (void)testGenericPasswordSubscripting
{
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
        
        keychain[@"username"] = @"kishikawa_katsumi";
        keychain[@"password"] = @"password_1234";
        
        NSString *username = keychain[@"username"];
        XCTAssertEqualObjects(username, @"kishikawa_katsumi");
        
        NSString *password = keychain[@"password"];
        XCTAssertEqualObjects(password, @"password_1234");
    }
    
    {
        // Update Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
        
        keychain[@"username"] = @"katsumi_kishikawa";
        keychain[@"password"] = @"1234_password";
        
        NSString *username = keychain[@"username"];
        XCTAssertEqualObjects(username, @"katsumi_kishikawa");
        
        NSString *password = keychain[@"password"];
        XCTAssertEqualObjects(password, @"1234_password");
    }
    
    {
        // Remove Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
        
        keychain[@"username"] = nil;
        keychain[@"password"] = nil;
        
        XCTAssertNil(keychain[@"username"]);
        XCTAssertNil(keychain[@"password"]);
    }
}

#pragma mark -

- (void)testInternetPassword
{
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        [keychain setString:@"kishikawa_katsumi" forKey:@"username"];
        [keychain setString:@"password_1234" forKey:@"password"];
        
        NSString *username = [keychain stringForKey:@"username"];
        XCTAssertEqualObjects(username, @"kishikawa_katsumi");
        
        NSString *password = [keychain stringForKey:@"password"];
        XCTAssertEqualObjects(password, @"password_1234");
    }
    
    {
        // Update Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        [keychain setString:@"katsumi_kishikawa" forKey:@"username"];
        [keychain setString:@"1234_password" forKey:@"password"];
        
        NSString *username = [keychain stringForKey:@"username"];
        XCTAssertEqualObjects(username, @"katsumi_kishikawa");
        
        NSString *password = [keychain stringForKey:@"password"];
        XCTAssertEqualObjects(password, @"1234_password");
    }
    
    {
        // Remove Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        [keychain removeItemForKey:@"username"];
        [keychain removeItemForKey:@"password"];
        
        XCTAssertNil([keychain stringForKey:@"username"]);
        XCTAssertNil([keychain stringForKey:@"password"]);
    }
}

- (void)testInternetPasswordSubscripting
{
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        keychain[@"username"] = @"kishikawa_katsumi";
        keychain[@"password"] = @"password_1234";
        
        NSString *username = keychain[@"username"];
        XCTAssertEqualObjects(username, @"kishikawa_katsumi");
        
        NSString *password = keychain[@"password"];
        XCTAssertEqualObjects(password, @"password_1234");
    }
    
    {
        // Update Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        keychain[@"username"] = @"katsumi_kishikawa";
        keychain[@"password"] = @"1234_password";
        
        NSString *username = keychain[@"username"];
        XCTAssertEqualObjects(username, @"katsumi_kishikawa");
        
        NSString *password = keychain[@"password"];
        XCTAssertEqualObjects(password, @"1234_password");
    }
    
    {
        // Remove Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        keychain[@"username"] = nil;
        keychain[@"password"] = nil;
        
        XCTAssertNil(keychain[@"username"]);
        XCTAssertNil(keychain[@"password"]);
    }
}

#pragma mark -

- (void)testSetDefaultService
{
    NSString *serviceName = @"com.kishikawakatsumi.UICKeyChainStore";
    [UICKeyChainStore setDefaultService:serviceName];
    XCTAssertEqualObjects(serviceName, [UICKeyChainStore defaultService], @"specitfy default service name");
}

#pragma mark -

- (void)testDefaultInitializer
{
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStore];
    XCTAssertEqualObjects(keychain.service, @"");
    XCTAssertNil(keychain.accessGroup);
    
    keychain = [[UICKeyChainStore alloc] init];
    XCTAssertEqualObjects(keychain.service, @"");
    XCTAssertNil(keychain.accessGroup);
}

- (void)testInitializerWithService
{
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
    XCTAssertEqualObjects(keychain.service, @"com.example.github-token");
    XCTAssertNil(keychain.accessGroup);
    
    keychain = [[UICKeyChainStore alloc] initWithService:@"com.example.github-token"];
    XCTAssertEqualObjects(keychain.service, @"com.example.github-token");
    XCTAssertNil(keychain.accessGroup);
}

- (void)testInitializerWithAccessGroup
{
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithService:nil accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertEqualObjects(keychain.service, @"");
    XCTAssertEqualObjects(keychain.accessGroup, @"12ABCD3E4F.shared");
    
    keychain = [[UICKeyChainStore alloc] initWithService:nil accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertEqualObjects(keychain.service, @"");
    XCTAssertEqualObjects(keychain.accessGroup, @"12ABCD3E4F.shared");
}

- (void)testInitializerWithServiceAndAccessGroup
{
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token" accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertEqualObjects(keychain.service, @"com.example.github-token");
    XCTAssertEqualObjects(keychain.accessGroup, @"12ABCD3E4F.shared");
    
    keychain = [[UICKeyChainStore alloc] initWithService:@"com.example.github-token" accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertEqualObjects(keychain.service, @"com.example.github-token");
    XCTAssertEqualObjects(keychain.accessGroup, @"12ABCD3E4F.shared");
}

- (void)testInitializerWithServer
{
    NSURL *URL = [NSURL URLWithString:@"https://kishikawakatsumi.com"];
    
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPS];
    XCTAssertEqualObjects(keychain.server, URL);
    XCTAssertEqual(keychain.protocolType, UICKeyChainStoreProtocolTypeHTTPS);
    XCTAssertEqual(keychain.authenticationType, UICKeyChainStoreAuthenticationTypeDefault);
    
    keychain = [[UICKeyChainStore alloc] initWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPS];
    XCTAssertEqualObjects(keychain.server, URL);
    XCTAssertEqual(keychain.protocolType, UICKeyChainStoreProtocolTypeHTTPS);
    XCTAssertEqual(keychain.authenticationType, UICKeyChainStoreAuthenticationTypeDefault);
}

- (void)testInitializerWithServerAndAuthenticationType
{
    NSURL *URL = [NSURL URLWithString:@"https://kishikawakatsumi.com"];
    
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPS authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
    XCTAssertEqualObjects(keychain.server, URL);
    XCTAssertEqual(keychain.protocolType, UICKeyChainStoreProtocolTypeHTTPS);
    XCTAssertEqual(keychain.authenticationType, UICKeyChainStoreAuthenticationTypeHTMLForm);
    
    keychain = [[UICKeyChainStore alloc] initWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPS authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
    XCTAssertEqualObjects(keychain.server, URL);
    XCTAssertEqual(keychain.protocolType, UICKeyChainStoreProtocolTypeHTTPS);
    XCTAssertEqual(keychain.authenticationType, UICKeyChainStoreAuthenticationTypeHTMLForm);
}

#pragma mark -

- (void)testContains
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertFalse([keychain contains:@"username"], @"not stored username");
    XCTAssertFalse([keychain contains:@"password"], @"not stored password");
    
    [keychain setString:@"kishikawa_katsumi" forKey:@"username"];
    XCTAssertTrue([keychain contains:@"username"], @"stored username");
    XCTAssertFalse([keychain contains:@"password"], @"not stored password");
    
    [keychain setString:@"password1234" forKey:@"password"];
    XCTAssertTrue([keychain contains:@"username"], @"stored username");
    XCTAssertTrue([keychain contains:@"password"], @"stored password");
}

#pragma mark -

- (void)testSetString
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertNil([keychain stringForKey:@"username"], @"not stored username");
    XCTAssertNil([keychain stringForKey:@"password"], @"not stored password");
    
    [keychain setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([keychain stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertNil([keychain stringForKey:@"password"], @"not stored password");
    
    [keychain setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([keychain stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([keychain stringForKey:@"password"], @"password1234", @"stored password");
}

- (void)testSetData
{
    NSDictionary *JSONObject = @{@"username": @"kishikawakatsumi", @"password": @"password1234"};
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:nil];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertNil([keychain dataForKey:@"JSONData"], @"not stored JSON data");
    
    [keychain setData:JSONData forKey:@"JSONData"];
    XCTAssertEqualObjects([keychain dataForKey:@"JSONData"], JSONData, @"stored JSON data");
}

- (void)testRemoveString
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertNil([keychain stringForKey:@"username"], @"not stored username");
    XCTAssertNil([keychain stringForKey:@"password"], @"not stored password");
    
    [keychain setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([keychain stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    
    [keychain setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([keychain stringForKey:@"password"], @"password1234", @"stored password");
    
    [keychain removeItemForKey:@"username"];
    XCTAssertNil([keychain stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([keychain stringForKey:@"password"], @"password1234", @"left password");
    
    [keychain removeItemForKey:@"password"];
    XCTAssertNil([keychain stringForKey:@"username"], @"removed username");
    XCTAssertNil([keychain stringForKey:@"password"], @"removed password");
}

- (void)testRemoveData
{
    NSDictionary *JSONObject = @{@"username": @"kishikawakatsumi", @"password": @"password1234"};
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:nil];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertNil([keychain dataForKey:@"JSONData"], @"not stored JSON data");
    
    [keychain setData:JSONData forKey:@"JSONData"];
    XCTAssertEqualObjects([keychain dataForKey:@"JSONData"], JSONData, @"stored JSON Data");
    
    [keychain removeItemForKey:@"JSONData"];
    XCTAssertNil([keychain dataForKey:@"JSONData"], @"removed JSON data");
}

#pragma mark -

- (void)testSubscripting
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    XCTAssertNil([keychain stringForKey:@"username"], @"not stored username");
    XCTAssertNil([keychain stringForKey:@"password"], @"not stored password");
    
    keychain[@"username"] = @"kishikawakatsumi";
    XCTAssertEqualObjects([keychain stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    
    keychain[@"password"] = @"password1234";
    XCTAssertEqualObjects([keychain stringForKey:@"password"], @"password1234", @"stored password");
    
    keychain[@"username"] = nil;
    XCTAssertNil([keychain stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([keychain stringForKey:@"password"], @"password1234", @"left password");
    
    keychain[@"password"] = nil;
    XCTAssertNil([keychain stringForKey:@"username"], @"removed username");
    XCTAssertNil([keychain stringForKey:@"password"], @"removed password");
}

#pragma mark -

#if TARGET_OS_IPHONE
- (void)testErrorHandling
{
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
        
        NSError *error;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        NSError *error;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStore];
        
        NSError *error;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error;
        BOOL succeeded = [keychain setString:@"kishikawa_katsumi" forKey:@"username" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        succeeded = [keychain setString:@"password_1234" forKey:@"password" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        NSString *username = [keychain stringForKey:@"username" error:&error];
        XCTAssertEqualObjects(username, @"kishikawa_katsumi");
        XCTAssertNil(error, "no error occurred");
        
        NSString *password = [keychain stringForKey:@"password" error:&error];
        XCTAssertEqualObjects(password, @"password_1234");
        XCTAssertNil(error, "no error occurred");
    }
    
    {
        // Update Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error;
        BOOL succeeded = [keychain setString:@"katsumi_kishikawa" forKey:@"username" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        succeeded = [keychain setString:@"1234_password" forKey:@"password" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        NSString *username = [keychain stringForKey:@"username" error:&error];
        XCTAssertEqualObjects(username, @"katsumi_kishikawa");
        XCTAssertNil(error, "no error occurred");
        
        NSString *password = [keychain stringForKey:@"password" error:&error];
        XCTAssertEqualObjects(password, @"1234_password");
        XCTAssertNil(error, "no error occurred");
    }
    
    {
        // Remove Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error;
        BOOL succeeded = [keychain removeItemForKey:@"username" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        succeeded = [keychain removeItemForKey:@"password" error:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
        
        XCTAssertNil([keychain stringForKey:@"username"]);
        XCTAssertNil([keychain stringForKey:@"password"]);
    }
}
#endif

#pragma mark -

- (void)testSetStringWithCustomService
{
    NSString *username_1 = @"kishikawakatsumi";
    NSString *password_1 = @"password1234";
    NSString *username_2 = @"kishikawa_katsumi";
    NSString *password_2 = @"password_1234";
    NSString *username_3 = @"k_katsumi";
    NSString *password_3 = @"12341234";
    
    NSString *service_1 = @"";
    NSString *service_2 = @"com.kishikawakatsumi.KeychainAccess";
    NSString *service_3 = @"example.com";
    
    [[UICKeyChainStore keyChainStore] removeAllItems];
    [[UICKeyChainStore keyChainStoreWithService:service_1] removeAllItems];
    [[UICKeyChainStore keyChainStoreWithService:service_2] removeAllItems];
    [[UICKeyChainStore keyChainStoreWithService:service_3] removeAllItems];
    
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"password"], @"not stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], @"not stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], @"not stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], @"not stored password");
    
    [[UICKeyChainStore keyChainStore] setString:username_1 forKey:@"username"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], @"not stored username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_1] setString:username_1 forKey:@"username"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], @"not stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], @"not stored username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_2] setString:username_2 forKey:@"username"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], username_2, @"stored username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], @"not stored username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_3] setString:username_3 forKey:@"username"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], username_1, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], username_2, @"stored username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], username_3, @"stored username");
    
    [[UICKeyChainStore keyChainStore] setString:password_1 forKey:@"password"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], @"not stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], @"not stored password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_1] setString:password_1 forKey:@"password"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], @"not stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], @"not stored password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_2] setString:password_2 forKey:@"password"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], password_2, @"stored password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], @"not stored password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_3] setString:password_3 forKey:@"password"];
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStore] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], password_1, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], password_2, @"stored password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], password_3, @"stored password");
    
    [[UICKeyChainStore keyChainStore] removeItemForKey:@"username"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], username_2, @"left username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], username_3, @"left username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_1] removeItemForKey:@"username"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], username_2, @"left username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], username_3, @"left username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_2] removeItemForKey:@"username"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], username_3, @"left username");
    
    [[UICKeyChainStore keyChainStoreWithService:service_3] removeItemForKey:@"username"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"username"], @"removed username");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"username"], @"removed username");
    
    [[UICKeyChainStore keyChainStore] removeItemForKey:@"password"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], @"removed password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], password_2, @"left password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], password_3, @"left password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_1] removeItemForKey:@"password"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], @"removed password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], password_2, @"left password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], password_3, @"left password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_2] removeItemForKey:@"password"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], @"removed password");
    XCTAssertEqualObjects([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], password_3, @"left password");
    
    [[UICKeyChainStore keyChainStoreWithService:service_3] removeItemForKey:@"password"];
    XCTAssertNil([[UICKeyChainStore keyChainStore] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_1] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_2] stringForKey:@"password"], @"removed password");
    XCTAssertNil([[UICKeyChainStore keyChainStoreWithService:service_3] stringForKey:@"password"], @"removed password");
}

#pragma mark -

- (void)testSetStringClassMethod
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
    [UICKeyChainStore setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"stored password");
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"left password");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"removed password");
    XCTAssertNil([store stringForKey:@"username"], @"removed username");
    XCTAssertNil([store stringForKey:@"password"], @"removed password");
}

#if TARGET_OS_IPHONE
- (void)testSetStringClassMethodAndError
{
    NSError *error;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItemsWithError:&error];
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setString:@"password1234" forKey:@"password" error:&error];
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username" error:&error], @"kishikawakatsumi", @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" error:&error], @"password1234", @"stored password");
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([store stringForKey:@"username" error:&error], @"kishikawakatsumi", @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:@"password" error:&error], @"password1234", @"stored password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" error:&error], @"password1234", @"left password");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:@"password" error:&error], @"password1234", @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"password" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password" error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:@"username" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([store stringForKey:@"password" error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
}
#endif

- (void)testSetNilStringClassMethod
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    
    [UICKeyChainStore setString:nil forKey:@"username"];
    [UICKeyChainStore setString:nil forKey:@"password"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"no password");
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
    [UICKeyChainStore setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"stored password");
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore setString:nil forKey:@"username"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"left password");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"left password");
    
    [UICKeyChainStore setString:nil forKey:@"password"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"removed password");
    XCTAssertNil([store stringForKey:@"username"], @"removed username");
    XCTAssertNil([store stringForKey:@"password"], @"removed password");
}

#pragma mark -

- (void)testSetDataClassMethod
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];

    [UICKeyChainStore setData:usernameData forKey:@"username"];
    [UICKeyChainStore setData:passwordData forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username"], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password"], passwordData, @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username" service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password"], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password" service:[UICKeyChainStore defaultService]];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"removed password");
}

#if TARGET_OS_IPHONE
- (void)testSetDataClassMethodAndError
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    [UICKeyChainStore setData:usernameData forKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username" error:&error], usernameData, @"stored username");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setData:passwordData forKey:@"password" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" error:&error], passwordData, @"stored password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"username" service:[UICKeyChainStore defaultService] error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" error:&error], passwordData, @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"password" service:[UICKeyChainStore defaultService] error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password" error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
}
#endif

- (void)testSetNilData
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    [UICKeyChainStore setData:nil forKey:@"username"];
    [UICKeyChainStore setData:nil forKey:@"password"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"no password");
    
    [UICKeyChainStore setData:usernameData forKey:@"username"];
    [UICKeyChainStore setData:passwordData forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username"], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password"], passwordData, @"stored password");
    
    [UICKeyChainStore setData:nil forKey:@"username"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password"], passwordData, @"left password");
    
    [UICKeyChainStore setData:nil forKey:@"password"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"removed password");
    
    [UICKeyChainStore removeItemForKey:@"username"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"removed password");
    
    [UICKeyChainStore removeItemForKey:@"password"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"removed password");
}

#pragma mark -

- (void)testClassMethodsSetAndRemoveItem
{
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username"], @"kishikawakatsumi");
    
    [UICKeyChainStore removeItemForKey:@"username"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"]);
}

#if TARGET_OS_IPHONE
- (void)testClassMethodsSetAndRemoveItemWithNoError
{
    NSError *error;
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    
    NSString *username = [UICKeyChainStore stringForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects(username, @"kishikawakatsumi");
    
    [UICKeyChainStore removeItemForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    
    username = [UICKeyChainStore stringForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    
    XCTAssertNil(username);
}
#endif

- (void)testInstanceMethodsSetAndRemoveItem
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    [store setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi");
    
    [store removeItemForKey:@"username"];
    XCTAssertNil([store stringForKey:@"username"]);
}

#if TARGET_OS_IPHONE
- (void)testInstanceMethodsSetAndRemoveItemWithNoError
{
    NSError *error;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    [store setString:@"kishikawakatsumi" forKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    
    NSString *username = [store stringForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects(username, @"kishikawakatsumi");
    
    [store removeItemForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    
    username = [store stringForKey:@"username" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil(username);
}
#endif

- (void)testInstanceMethodsSetAndRemoveWithNilValue
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    [store setString:@"kishikawakatsumi" forKey:@"username"];
    
    NSString *username = [store stringForKey:@"username"];
    XCTAssertEqualObjects(username, @"kishikawakatsumi");
    
    [store setString:nil forKey:@"username"];
    
    username = [store stringForKey:@"username"];
    XCTAssertNil(username);
}

@end
