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

#if TARGET_OS_IPHONE
- (void)testSetDataWithNoError
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey error:&error], usernameData, @"stored username");
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey error:&error], passwordData, @"stored password");
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
}
#endif

- (void)testSetNilData
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    [UICKeyChainStore setData:nil forKey:usernameKey];
    [UICKeyChainStore setData:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"no password");
    
    [UICKeyChainStore setData:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:usernameKey];
    [UICKeyChainStore setData:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:passwordKey];
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:usernameKey], usernameData, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"stored password");
    
    [UICKeyChainStore setData:nil forKey:usernameKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore dataForKey:passwordKey], passwordData, @"left password");
    
    [UICKeyChainStore setData:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
    
    [UICKeyChainStore removeItemForKey:usernameKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"removed password");
    
    [UICKeyChainStore removeItemForKey:passwordKey];
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

#if TARGET_OS_IPHONE
- (void)testSetUsernameAndPasswordWithNoError
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    
    NSError *error;
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItemsWithError:&error];
    XCTAssertNil(error, @"no error");
    
    [UICKeyChainStore setString:username forKey:usernameKey error:&error];
    XCTAssertNil(error, @"no error");
    [UICKeyChainStore setString:password forKey:passwordKey error:&error];
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey error:&error], password, @"stored password");
    XCTAssertNil(error, @"no error");
    
    XCTAssertEqualObjects([store stringForKey:usernameKey error:&error], username, @"stored username");
    XCTAssertNil(error, @"no error");
    XCTAssertEqualObjects([store stringForKey:passwordKey error:&error], password, @"stored password");
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
}
#endif

- (void)testSetNilUsernameAndNilPassword
{
    NSString *usernameKey = @"username";
    NSString *passwordKey = @"password";
    NSString *username = @"kishikawakatsumi";
    NSString *password = @"password1234";
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store removeAllItems];
    
    [UICKeyChainStore setString:nil forKey:usernameKey];
    [UICKeyChainStore setString:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore dataForKey:usernameKey], @"no username");
    XCTAssertNil([UICKeyChainStore dataForKey:passwordKey], @"no password");
    
    [UICKeyChainStore setString:username forKey:usernameKey];
    [UICKeyChainStore setString:password forKey:passwordKey];
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"stored password");
    XCTAssertEqualObjects([store stringForKey:usernameKey], username, @"stored username");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"stored password");
    
    [UICKeyChainStore setString:nil forKey:usernameKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertEqualObjects([UICKeyChainStore stringForKey:passwordKey], password, @"left password");
    XCTAssertEqualObjects([store stringForKey:passwordKey], password, @"left password");
    
    [UICKeyChainStore setString:nil forKey:passwordKey];
    XCTAssertNil([UICKeyChainStore stringForKey:usernameKey], @"removed username");
    XCTAssertNil([UICKeyChainStore stringForKey:passwordKey], @"removed password");
    XCTAssertNil([store stringForKey:usernameKey], @"removed username");
    XCTAssertNil([store stringForKey:passwordKey], @"removed password");
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

#if TARGET_OS_IPHONE
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
#endif

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
}

#if TARGET_OS_IPHONE
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
}
#endif

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
