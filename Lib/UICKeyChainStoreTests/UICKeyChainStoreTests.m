//
//  UICKeyChainStoreTests.m
//  UICKeyChainStoreTests
//
//  Created by kishikawa katsumi on 2014/06/22.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UICKeyChainStore.h"

@interface UICKeyChainStore (Private)

- (CFTypeRef)protocolTypeObject;
- (CFTypeRef)authenticationTypeObject;
- (CFTypeRef)accessibilityObject;

@end

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

#if TARGET_OS_IPHONE
- (void)testRemoveAllItemsWithErrorClassMethod
{
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"not stored username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"not stored password");
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    
    [UICKeyChainStore setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"stored password");
    
    NSError *error = nil;
    [UICKeyChainStore removeAllItemsWithError:&error];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"removed password");
    XCTAssertNil(error);
}
#else
- (void)testRemoveAllItemsWithErrorClassMethod
{
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"not stored username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"not stored password");
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    
    [UICKeyChainStore setString:@"password1234" forKey:@"password"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeAllItemsWithError:nil];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"removed password");
}
#endif


- (void)testRemoveAllItemsForServiceClassMethod
{
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter"], @"not stored username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"not stored password");
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"Twitter"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username" service:@"Twitter"], @"kishikawakatsumi", @"stored username");
    
    [UICKeyChainStore setString:@"password1234" forKey:@"password" service:@"Twitter"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeAllItemsForService:@"Twitter" error:nil];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password"], @"removed password");
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
        
        NSError *error = nil;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error = nil;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
        
        NSError *error = nil;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStore];
        
        NSError *error = nil;
        BOOL succeeded = [keychain removeAllItemsWithError:&error];
        XCTAssertNil(error, "no error occurred");
        XCTAssertTrue(succeeded, "succeeded");
    }
    
    {
        // Add Keychain items
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
        
        NSError *error = nil;
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
        
        NSError *error = nil;
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
        
        NSError *error = nil;
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

- (void)testSetStringWithServiceClassMethod1
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    [store removeAllItems];
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"Twitter"];
    [UICKeyChainStore setString:@"password1234" forKey:@"password" service:@"Twitter"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username" service:@"Twitter"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"password1234", @"stored password");
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"password1234", @"left password");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"removed password");
    XCTAssertNil([store stringForKey:@"username"], @"removed username");
    XCTAssertNil([store stringForKey:@"password"], @"removed password");
}

#if TARGET_OS_IPHONE
- (void)testSetStringWithServiceClassMethod2
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    [store removeAllItems];
    
    NSError *error = nil;
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"Twitter" error:&error];
    XCTAssertNil(error);
    [UICKeyChainStore setString:@"password1234" forKey:@"password" service:@"Twitter" error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username" service:@"Twitter" error:&error], @"kishikawakatsumi", @"stored username");
    XCTAssertNil(error);
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter" error:&error], @"password1234", @"stored password");
    XCTAssertNil(error);
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter" error:&error];
    XCTAssertNil(error);
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter" error:&error], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter" error:&error], @"password1234", @"left password");
    XCTAssertNil(error);
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter" error:&error];
    XCTAssertNil(error);
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter" error:&error], @"removed username");
    XCTAssertNil(error);
    XCTAssertNil([UICKeyChainStore stringForKey:@"password" service:@"Twitter" error:&error], @"removed password");
    XCTAssertNil(error);
    XCTAssertNil([store stringForKey:@"username"], @"removed username");
    XCTAssertNil([store stringForKey:@"password"], @"removed password");
}
#endif

- (void)testSetStringWithServiceAndAccessGroupClassMethod
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
    [store removeAllItems];
    
    [UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
    [UICKeyChainStore setString:@"password1234" forKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"], @"password1234", @"stored password");
    XCTAssertEqualObjects([store stringForKey:@"username"], @"kishikawakatsumi", @"stored username");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"password" service:@"Twitter"], @"password1234", @"left password");
    XCTAssertEqualObjects([store stringForKey:@"password"], @"password1234", @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"];
    XCTAssertNil([UICKeyChainStore stringForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared"], @"removed password");
    XCTAssertNil([store stringForKey:@"username"], @"removed username");
    XCTAssertNil([store stringForKey:@"password"], @"removed password");
}

#if TARGET_OS_IPHONE
- (void)testSetStringClassMethodAndError
{
    NSError *error = nil;
    
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
    
    [UICKeyChainStore removeItemForKey:@"username"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password"], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password"], @"removed password");
}

- (void)testSetDataWithServiceClassMethod
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    [UICKeyChainStore setData:usernameData forKey:@"username" service:@"Twitter"];
    [UICKeyChainStore setData:passwordData forKey:@"password" service:@"Twitter"];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username" service:@"Twitter"], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter"], passwordData, @"stored password");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter"], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter"], passwordData, @"left password");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter"];
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter"], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password" service:@"Twitter"], @"removed password");
}

#if TARGET_OS_IPHONE
- (void)testSetDataClassMethodAndError
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
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

- (void)testSetDataWithServiceClassMethodAndError
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [UICKeyChainStore setData:usernameData forKey:@"username" service:@"Twitter" error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setData:passwordData forKey:@"password" service:@"Twitter" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username" service:@"Twitter" error:&error], usernameData, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter" error:&error], passwordData, @"stored password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter" error:&error], passwordData, @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password" service:@"Twitter" error:&error], @"removed password");
    XCTAssertNil(error, @"no error");
}

- (void)testSetDataWithServiceAndAccessGroupClassMethodAndError
{
    NSData *usernameData = [@"kishikawakatsumi" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [@"password1234" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [UICKeyChainStore setData:usernameData forKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setData:passwordData forKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], usernameData, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], passwordData, @"stored password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], passwordData, @"left password");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore removeItemForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"username" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], @"removed username");
    XCTAssertNil(error, @"no error");
    XCTAssertNil([UICKeyChainStore dataForKey:@"password" service:@"Twitter" accessGroup:@"12ABCD3E4F.shared" error:&error], @"removed password");
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
    NSError *error = nil;
    
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
    NSError *error = nil;
    
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

#pragma mark -

- (void)testGetAllKeys1
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"github.com"];
    [store removeAllItems];
    
    [store setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
    [store setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada"];
    [store setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon"];
    
    NSArray *allKeys = store.allKeys;
    XCTAssertTrue([allKeys containsObject:@"kishikawakatsumi"]);
    XCTAssertTrue([allKeys containsObject:@"hirohamada"]);
    XCTAssertTrue([allKeys containsObject:@"honeylemon"]);
    
    XCTAssertEqual(allKeys.count, 3);
    
    [store removeAllItems];
}

- (void)testGetAllKeys2
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
    [store removeAllItems];
    
    [store setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
    [store setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada"];
    [store setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon"];
    
    NSArray *allKeys = store.allKeys;
    XCTAssertTrue([allKeys containsObject:@"kishikawakatsumi"]);
    XCTAssertTrue([allKeys containsObject:@"hirohamada"]);
    XCTAssertTrue([allKeys containsObject:@"honeylemon"]);
    
    XCTAssertEqual(allKeys.count, 3);
    
    [store removeAllItems];
}

- (void)testGetAllItems1
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"github.com"];
    [store removeAllItems];
    
    [store setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
    [store setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada"];
    [store setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon"];
    
    NSArray *allItems = store.allItems;
    for (NSDictionary *item in allItems) {
        if ([item[@"key"] isEqualToString:@"kishikawakatsumi"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"01234567-89ab-cdef-0123-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"hirohamada"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"00000000-89ab-cdef-0000-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"honeylemon"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"11111111-89ab-cdef-1111-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
    }
    
    XCTAssertEqual(allItems.count, 3);
    
    [store removeAllItems];
}

- (void)testGetAllItems2
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
    [store removeAllItems];
    
    [store setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
    [store setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada"];
    [store setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon"];
    
    NSArray *allItems = store.allItems;
    for (NSDictionary *item in allItems) {
        if ([item[@"key"] isEqualToString:@"kishikawakatsumi"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"01234567-89ab-cdef-0123-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"server"], @"kishikawakatsumi.com");
            XCTAssertEqualObjects(item[@"protocol"], (__bridge id)kSecAttrProtocolHTTPS);
            XCTAssertEqualObjects(item[@"authenticationType"], (__bridge id)kSecAttrAuthenticationTypeDefault);
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"hirohamada"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"00000000-89ab-cdef-0000-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"server"], @"kishikawakatsumi.com");
            XCTAssertEqualObjects(item[@"protocol"], (__bridge id)kSecAttrProtocolHTTPS);
            XCTAssertEqualObjects(item[@"authenticationType"], (__bridge id)kSecAttrAuthenticationTypeDefault);
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"honeylemon"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"11111111-89ab-cdef-1111-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"server"], @"kishikawakatsumi.com");
            XCTAssertEqualObjects(item[@"protocol"], (__bridge id)kSecAttrProtocolHTTPS);
            XCTAssertEqualObjects(item[@"authenticationType"], (__bridge id)kSecAttrAuthenticationTypeDefault);
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
    }
    
    XCTAssertEqual(allItems.count, 3);
    
    [store removeAllItems];
}

- (void)testGetAllKeysGenericPasswordClassMethod
{
    [UICKeyChainStore removeAllItemsForService:@"github.com"];
    
    [UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi" service:@"github.com"];
    [UICKeyChainStore setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada" service:@"github.com"];
    [UICKeyChainStore setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon" service:@"github.com"];
    
    NSArray *allKeysAndServices = [UICKeyChainStore allKeysWithItemClass:UICKeyChainStoreItemClassGenericPassword];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (NSDictionary *keyAndService in allKeysAndServices) {
        if ([keyAndService[@"service"] isEqualToString:@"github.com"]) {
            [keys addObject:keyAndService[@"key"]];
        }
    }
    
    XCTAssertTrue([keys containsObject:@"kishikawakatsumi"]);
    XCTAssertTrue([keys containsObject:@"hirohamada"]);
    XCTAssertTrue([keys containsObject:@"honeylemon"]);
    
    [UICKeyChainStore removeAllItemsForService:@"github.com"];
}

- (void)testGetAllItemsClassMethod
{
    [UICKeyChainStore removeAllItemsForService:@"github.com"];
    
    [UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi" service:@"github.com"];
    [UICKeyChainStore setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada" service:@"github.com"];
    [UICKeyChainStore setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon" service:@"github.com"];
    
    NSArray *allItems = [UICKeyChainStore allItemsWithItemClass:UICKeyChainStoreItemClassGenericPassword];
    for (NSDictionary *item in allItems) {
        if ([item[@"key"] isEqualToString:@"kishikawakatsumi"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"01234567-89ab-cdef-0123-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"hirohamada"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"00000000-89ab-cdef-0000-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
        if ([item[@"key"] isEqualToString:@"honeylemon"]) {
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"value"], @"11111111-89ab-cdef-1111-456789abcdef");
#else
            XCTAssertEqualObjects(item[@"value"], @"");
#endif
            XCTAssertEqualObjects(item[@"service"], @"github.com");
#if TARGET_OS_IPHONE
            XCTAssertEqualObjects(item[@"accessibility"], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
#endif
        }
    }
    
    [UICKeyChainStore removeAllItemsForService:@"github.com"];
}

#pragma mark -

- (void)testSetStringLabelAndComment
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    [store setString:@"kishikawakatsumi" forKey:@"username" label:@"Label" comment:@"Comment"];
    
    NSString *username = [store stringForKey:@"username"];
    XCTAssertEqualObjects(username, @"kishikawakatsumi");
    
    [store setString:nil forKey:@"username"];
    
    username = [store stringForKey:@"username"];
    XCTAssertNil(username);
}

- (void)testSetDataLabelAndComment
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@[@"Keychain"]];
    [store setData:data forKey:@"data" label:@"Label" comment:@"Comment"];
    XCTAssertEqualObjects(data, [store dataForKey:@"data"]);
}

#pragma mark -

- (void)testDescription
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"github.com"];
    [store removeAllItems];
    
    [store setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
    [store setString:@"00000000-89ab-cdef-0000-456789abcdef" forKey:@"hirohamada"];
    [store setString:@"11111111-89ab-cdef-1111-456789abcdef" forKey:@"honeylemon"];
    
#if TARGET_OS_IPHONE
    NSString *description = @"(\n" \
    @"    {\n"
    @"    accessGroup = \"\";\n" \
    @"    accessibility = ck;\n" \
    @"    class = GenericPassword;\n" \
    @"    key = kishikawakatsumi;\n" \
    @"    service = \"github.com\";\n" \
    @"    synchronizable = 0;\n" \
    @"    value = \"01234567-89ab-cdef-0123-456789abcdef\";\n" \
    @"}    {\n" \
    @"    accessGroup = \"\";\n" \
    @"    accessibility = ck;\n" \
    @"    class = GenericPassword;\n" \
    @"    key = hirohamada;\n" \
    @"    service = \"github.com\";\n" \
    @"    synchronizable = 0;\n" \
    @"    value = \"00000000-89ab-cdef-0000-456789abcdef\";\n" \
    @"}    {\n" \
    @"    accessGroup = \"\";\n" \
    @"    accessibility = ck;\n" \
    @"    class = GenericPassword;\n" \
    @"    key = honeylemon;\n" \
    @"    service = \"github.com\";\n" \
    @"    synchronizable = 0;\n" \
    @"    value = \"11111111-89ab-cdef-1111-456789abcdef\";\n" \
    @"})";
#else
    NSString *description = @"(\n" \
    @"    {\n"
    @"    class = GenericPassword;\n" \
    @"    key = kishikawakatsumi;\n" \
    @"    service = \"github.com\";\n" \
    @"    value = \"\";\n" \
    @"}    {\n" \
    @"    class = GenericPassword;\n" \
    @"    key = hirohamada;\n" \
    @"    service = \"github.com\";\n" \
    @"    value = \"\";\n" \
    @"}    {\n" \
    @"    class = GenericPassword;\n" \
    @"    key = honeylemon;\n" \
    @"    service = \"github.com\";\n" \
    @"    value = \"\";\n" \
    @"})";
#endif
    XCTAssertEqualObjects(store.description, description);
    
    [store removeAllItems];
}

#pragma mark -

- (void)testStringConversionError
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@[@"Keychain"]];
    
    [store setData:data forKey:@"data"];
    
    NSError *error = nil;
    NSString *s = [store stringForKey:@"data" error:&error];
    XCTAssertNil(s);
    XCTAssertNotNil(error);
}

- (void)testArgumentError
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    NSError *error = nil;
    [store setString:@"kishikawakatsumi" forKey:nil error:&error];
    XCTAssertNotNil(error);
}

- (void)testProtocolTypeAndAuthenticationTypePrivateMethod
{
    NSURL *URL = [NSURL URLWithString:@"https://kishikawakatsumi.com"];
    
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeFTP authenticationType:UICKeyChainStoreAuthenticationTypeNTLM];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolFTP);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeNTLM);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeFTPAccount authenticationType:UICKeyChainStoreAuthenticationTypeMSN];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolFTPAccount);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeMSN);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTP authenticationType:UICKeyChainStoreAuthenticationTypeDPA];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolHTTP);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeDPA);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeIRC authenticationType:UICKeyChainStoreAuthenticationTypeRPA];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolIRC);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeRPA);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeNNTP authenticationType:UICKeyChainStoreAuthenticationTypeHTTPBasic];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolNNTP);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeHTTPBasic);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypePOP3 authenticationType:UICKeyChainStoreAuthenticationTypeHTTPDigest];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolPOP3);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeHTTPDigest);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeSMTP authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolSMTP);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeHTMLForm);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeSOCKS authenticationType:UICKeyChainStoreAuthenticationTypeDefault];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolSOCKS);
    XCTAssertEqualObjects([keychain authenticationTypeObject], (__bridge id)kSecAttrAuthenticationTypeDefault);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeIMAP];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolIMAP);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeLDAP];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolLDAP);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeAppleTalk];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolAppleTalk);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeAFP];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolAFP);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeTelnet];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolTelnet);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeSSH];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolSSH);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeFTPS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolFTPS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolHTTPS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPProxy];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolHTTPProxy);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeHTTPSProxy];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolHTTPSProxy);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeFTPProxy];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolFTPProxy);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeSMB];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolSMB);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeRTSP];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolRTSP);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeRTSPProxy];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolRTSPProxy);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeDAAP];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolDAAP);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeEPPC];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolEPPC);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeNNTPS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolNNTPS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeLDAPS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolLDAPS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeTelnetS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolTelnetS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypeIRCS];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolIRCS);
    
    keychain = [UICKeyChainStore keyChainStoreWithServer:URL protocolType:UICKeyChainStoreProtocolTypePOP3S];
    XCTAssertEqualObjects([keychain protocolTypeObject], (__bridge id)kSecAttrProtocolPOP3S);
}

#pragma mark -

- (void)testAccessibilityPrivateMethod
{
    UICKeyChainStore *keychain;
    
    keychain = [UICKeyChainStore keyChainStoreWithService:@"Twitter"];
    
    keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleWhenUnlocked);
    
    keychain.accessibility = UICKeyChainStoreAccessibilityAfterFirstUnlock;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleAfterFirstUnlock);
    
    keychain.accessibility = UICKeyChainStoreAccessibilityAlways;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleAlways);
    
#if TARGET_OS_IPHONE
    keychain.accessibility = UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly);
#endif
    
    keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
    
    keychain.accessibility = UICKeyChainStoreAccessibilityAfterFirstUnlockThisDeviceOnly;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
    
    keychain.accessibility = UICKeyChainStoreAccessibilityAlwaysThisDeviceOnly;
    XCTAssertEqualObjects([keychain accessibilityObject], (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly);
}

@end
