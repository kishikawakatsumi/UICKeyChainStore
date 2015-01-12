//
//  UICKeyChainStore.h
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UICKeyChainStoreErrorDomain;

typedef NS_ENUM(NSInteger, UICKeyChainStoreErrorCode) {
    UICKeyChainStoreErrorInvalidArguments = 1,
};

typedef NS_ENUM(NSInteger, UICKeyChainStoreItemClass) {
    UICKeyChainStoreItemClassGenericPassword = 1,
    UICKeyChainStoreItemClassInternetPassword,
};

typedef NS_ENUM(NSInteger, UICKeyChainStoreProtocolType) {
    UICKeyChainStoreProtocolTypeFTP = 1,
    UICKeyChainStoreProtocolTypeFTPAccount,
    UICKeyChainStoreProtocolTypeHTTP,
    UICKeyChainStoreProtocolTypeIRC,
    UICKeyChainStoreProtocolTypeNNTP,
    UICKeyChainStoreProtocolTypePOP3,
    UICKeyChainStoreProtocolTypeSMTP,
    UICKeyChainStoreProtocolTypeSOCKS,
    UICKeyChainStoreProtocolTypeIMAP,
    UICKeyChainStoreProtocolTypeLDAP,
    UICKeyChainStoreProtocolTypeAppleTalk,
    UICKeyChainStoreProtocolTypeAFP,
    UICKeyChainStoreProtocolTypeTelnet,
    UICKeyChainStoreProtocolTypeSSH,
    UICKeyChainStoreProtocolTypeFTPS,
    UICKeyChainStoreProtocolTypeHTTPS,
    UICKeyChainStoreProtocolTypeHTTPProxy,
    UICKeyChainStoreProtocolTypeHTTPSProxy,
    UICKeyChainStoreProtocolTypeFTPProxy,
    UICKeyChainStoreProtocolTypeSMB,
    UICKeyChainStoreProtocolTypeRTSP,
    UICKeyChainStoreProtocolTypeRTSPProxy,
    UICKeyChainStoreProtocolTypeDAAP,
    UICKeyChainStoreProtocolTypeEPPC,
    UICKeyChainStoreProtocolTypeNNTPS,
    UICKeyChainStoreProtocolTypeLDAPS,
    UICKeyChainStoreProtocolTypeTelnetS,
    UICKeyChainStoreProtocolTypeIRCS,
    UICKeyChainStoreProtocolTypePOP3S,
};

typedef NS_ENUM(NSInteger, UICKeyChainStoreAuthenticationType) {
    UICKeyChainStoreAuthenticationTypeNTLM = 1,
    UICKeyChainStoreAuthenticationTypeMSN,
    UICKeyChainStoreAuthenticationTypeDPA,
    UICKeyChainStoreAuthenticationTypeRPA,
    UICKeyChainStoreAuthenticationTypeHTTPBasic,
    UICKeyChainStoreAuthenticationTypeHTTPDigest,
    UICKeyChainStoreAuthenticationTypeHTMLForm,
    UICKeyChainStoreAuthenticationTypeDefault,
};

typedef NS_ENUM(NSInteger, UICKeyChainStoreAccessibility) {
    UICKeyChainStoreAccessibilityWhenUnlocked = 1,
    UICKeyChainStoreAccessibilityAfterFirstUnlock,
    UICKeyChainStoreAccessibilityAlways,
    UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
    __OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0),
    UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly,
    UICKeyChainStoreAccessibilityAfterFirstUnlockThisDeviceOnly,
    UICKeyChainStoreAccessibilityAlwaysThisDeviceOnly,
};

typedef NS_ENUM(NSInteger, UICKeyChainStoreAuthenticationPolicy) {
    UICKeyChainStoreAuthenticationPolicyUserPresence = kSecAccessControlUserPresence,
};

@interface UICKeyChainStore : NSObject

@property (nonatomic, readonly) UICKeyChainStoreItemClass itemClass;

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;

@property (nonatomic, readonly) NSURL *server;
@property (nonatomic, readonly) UICKeyChainStoreProtocolType protocolType;
@property (nonatomic, readonly) UICKeyChainStoreAuthenticationType authenticationType;

@property (nonatomic) UICKeyChainStoreAccessibility accessibility;
@property (nonatomic, readonly) UICKeyChainStoreAuthenticationPolicy authenticationPolicy
__OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

@property (nonatomic) BOOL synchronizable;

@property (nonatomic) NSString *authenticationPrompt
__OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_8_0);

+ (NSString *)defaultService;
+ (void)setDefaultService:(NSString *)defaultService;

+ (UICKeyChainStore *)keyChainStore;
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (UICKeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType;
+ (UICKeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType authenticationType:(UICKeyChainStoreAuthenticationType)authenticationType;

- (instancetype)init;
- (instancetype)initWithService:(NSString *)service;
- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (instancetype)initWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType;
- (instancetype)initWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType authenticationType:(UICKeyChainStoreAuthenticationType)authenticationType;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

+ (NSData *)dataForKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

- (BOOL)contains:(NSString *)key;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError * __autoreleasing *)error;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key error:(NSError * __autoreleasing *)error;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError * __autoreleasing *)error;
- (NSData *)dataForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key error:(NSError * __autoreleasing *)error;

+ (BOOL)removeItemForKey:(NSString *)key;
+ (BOOL)removeItemForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;
+ (BOOL)removeAllItems;
+ (BOOL)removeAllItemsWithError:(NSError * __autoreleasing *)error;
+ (BOOL)removeAllItemsForService:(NSString *)service;
+ (BOOL)removeAllItemsForService:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

- (BOOL)removeItemForKey:(NSString *)key;
- (BOOL)removeItemForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)removeAllItems;
- (BOOL)removeAllItemsWithError:(NSError * __autoreleasing *)error;

- (NSString *)objectForKeyedSubscript:(NSString <NSCopying> *)key;
- (void)setObject:(NSString *)obj forKeyedSubscript:(NSString <NSCopying> *)key;

+ (NSArray *)allKeysWithItemClass:(CFTypeRef)itemClass;
- (NSArray *)allKeys;

+ (NSArray *)allItemsWithItemClass:(CFTypeRef)itemClass;
- (NSArray *)allItems;

- (void)setAccessibility:(UICKeyChainStoreAccessibility)accessibility authenticationPolicy:(UICKeyChainStoreAuthenticationPolicy)authenticationPolicy
__OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

- (void)synchronize __attribute__((deprecated("calling this method is no longer required")));
- (BOOL)synchronizeWithError:(NSError *__autoreleasing *)error __attribute__((deprecated("calling this method is no longer required")));

@end
