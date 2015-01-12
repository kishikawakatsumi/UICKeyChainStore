//
//  UICKeyChainStore.m
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UICKeyChainStore.h"

NSString * const UICKeyChainStoreErrorDomain = @"com.kishikawakatsumi.uickeychainstore";
static NSString *_defaultService;

@interface UICKeyChainStore ()

@end

@implementation UICKeyChainStore

+ (NSString *)defaultService
{
    if (!_defaultService) {
        _defaultService = [[NSBundle mainBundle] bundleIdentifier] ?: @"";
    }
    
    return _defaultService;
}

+ (void)setDefaultService:(NSString *)defaultService
{
    _defaultService = defaultService;
}

#pragma mark -

+ (UICKeyChainStore *)keyChainStore
{
    return [[self alloc] initWithService:nil accessGroup:nil];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service
{
    return [[self alloc] initWithService:service accessGroup:nil];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [[self alloc] initWithService:service accessGroup:accessGroup];
}

#pragma mark -

+ (UICKeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType
{
    return [[self alloc] initWithServer:server protocolType:protocolType authenticationType:UICKeyChainStoreAuthenticationTypeDefault];
}

+ (UICKeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType authenticationType:(UICKeyChainStoreAuthenticationType)authenticationType
{
    return [[self alloc] initWithServer:server protocolType:protocolType authenticationType:authenticationType];
}

#pragma mark -

- (instancetype)init
{
    return [self initWithService:[self.class defaultService] accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service
{
    return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    self = [super init];
    if (self) {
        _itemClass = UICKeyChainStoreItemClassGenericPassword;
        
        if (!service) {
            service = [self.class defaultService];
        }
        _service = service.copy;
        _accessGroup = accessGroup.copy;
        [self commonInit];
    }
    
    return self;
}

#pragma mark -

- (instancetype)initWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType
{
    return [self initWithServer:server protocolType:protocolType authenticationType:UICKeyChainStoreAuthenticationTypeDefault];
}

- (instancetype)initWithServer:(NSURL *)server protocolType:(UICKeyChainStoreProtocolType)protocolType authenticationType:(UICKeyChainStoreAuthenticationType)authenticationType
{
    self = [super init];
    if (self) {
        _itemClass = UICKeyChainStoreItemClassInternetPassword;
        
        _server = server.copy;
        _protocolType = protocolType;
        _authenticationType = authenticationType;
        
        [self commonInit];
    }
    
    return self;
}

#pragma mark -

- (void)commonInit
{
    _accessibility = UICKeyChainStoreAccessibilityAfterFirstUnlock;
}

#pragma mark -

+ (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key service:nil accessGroup:nil error:nil];
}

+ (NSString *)stringForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key service:nil accessGroup:nil error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service
{
    return [self stringForKey:key service:service accessGroup:nil error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key service:service accessGroup:nil error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self stringForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [self argumentError:NSLocalizedString(@"the key must not to be nil", nil)];
        }
        return nil;
    }
    if (!service) {
        service = [self defaultService];
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
    return [keychain stringForKey:key error:error];
}

#pragma mark -

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [self setString:value forKey:key service:nil accessGroup:nil error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setString:value forKey:key service:nil accessGroup:nil error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service
{
    return [self setString:value forKey:key service:service accessGroup:nil error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self setString:value forKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self setString:value forKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    if (!value) {
        return [self removeItemForKey:key service:service accessGroup:accessGroup error:error];
    }
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [self setData:data forKey:key service:service accessGroup:accessGroup error:error];
    }
    if (error) {
        *error = [self conversionError:NSLocalizedString(@"failed to convert string to data", nil)];
    }
    return NO;
}

#pragma mark -

+ (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key service:nil accessGroup:nil error:nil];
}

+ (NSData *)dataForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key service:nil accessGroup:nil error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service
{
    return [self dataForKey:key service:service accessGroup:nil error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key service:service accessGroup:nil error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self dataForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [self argumentError:NSLocalizedString(@"the key must not to be nil", nil)];
        }
        return nil;
    }
    if (!service) {
        service = [self defaultService];
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
    return [keychain dataForKey:key error:error];
}

#pragma mark -

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key
{
    return [self setData:data forKey:key service:nil accessGroup:nil error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key service:nil accessGroup:nil error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service
{
    return [self setData:data forKey:key service:service accessGroup:nil error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self setData:data forKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [self argumentError:NSLocalizedString(@"the key must not to be nil", nil)];
        }
        return NO;
    }
    if (!service) {
        service = [self defaultService];
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
    return [keychain setData:data forKey:key error:error];
}

#pragma mark -

- (BOOL)contains:(NSString *)key
{
    NSMutableDictionary *query = [self query];
    query[(__bridge __strong id)kSecAttrAccount] = key;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    return status == errSecSuccess;
}

#pragma mark -

- (NSString *)stringForKey:(id)key
{
    return [self stringForKey:key error:nil];
}

- (NSString *)stringForKey:(id)key error:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataForKey:key error:error];
    if (data) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            return string;
        }
        if (error) {
            *error = [self.class conversionError:NSLocalizedString(@"failed to convert data to string", nil)];
        }
        return nil;
    }
    
    return nil;
}

#pragma mark -

- (BOOL)setString:(NSString *)string forKey:(NSString *)key
{
    return [self setString:string forKey:key label:nil comment:nil error:nil];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setString:string forKey:key label:nil comment:nil error:error];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment
{
    return [self setString:string forKey:key label:label comment:comment error:nil];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError *__autoreleasing *)error
{
    if (!string) {
        return [self removeItemForKey:key error:error];
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [self setData:data forKey:key label:label comment:comment error:error];
    }
    if (error) {
        *error = [self.class conversionError:NSLocalizedString(@"failed to convert string to data", nil)];
    }
    return NO;
}

#pragma mark -

- (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key error:nil];
}

- (NSData *)dataForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *query = [self query];
    query[(__bridge __strong id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge __strong id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    
    query[(__bridge __strong id)kSecAttrAccount] = key;
    
    CFTypeRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    
    if (status == errSecSuccess) {
        NSData *ret = [NSData dataWithData:(__bridge NSData *)data];
        if (data) {
            CFRelease(data);
            return ret;
        } else {
            if (error) {
                *error = [self.class unexpectedError:NSLocalizedString(@"Unexpected error has occurred.", nil)];
            }
            return nil;
        }
    } else if (status == errSecItemNotFound) {
        return nil;
    }
    
    if (error) {
        *error = [self.class securityError:status];
    }
    return nil;
}

#pragma mark -

- (BOOL)setData:(NSData *)data forKey:(NSString *)key
{
    return [self setData:data forKey:key label:nil comment:nil error:nil];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key label:nil comment:nil error:error];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment
{
    return [self setData:data forKey:key label:label comment:comment error:nil];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError *__autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [self.class argumentError:NSLocalizedString(@"the key must not to be nil", nil)];
        }
        return NO;
    }
    if (!data) {
        return [self removeItemForKey:key error:error];
    }
    
    NSMutableDictionary *query = [self query];
    query[(__bridge __strong id)kSecAttrAccount] = key;
#if TARGET_OS_IPHONE
    if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+
        query[(__bridge __strong id)kSecUseNoAuthenticationUI] = (__bridge id)kCFBooleanTrue;
    }
#endif
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecSuccess || status == errSecInteractionNotAllowed) {
#if TARGET_OS_IPHONE
        if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+
            [query removeObjectForKey:(__bridge id)kSecUseNoAuthenticationUI];
        }
#endif
        NSError *unexpectedError;
        NSMutableDictionary *attributes = [self attributesWithKey:nil value:data error:&unexpectedError];
        
        if (label) {
            attributes[(__bridge __strong id)kSecAttrLabel] = label;
        }
        if (comment) {
            attributes[(__bridge __strong id)kSecAttrComment] = comment;
        }
        
        if (unexpectedError) {
            if (error) {
                *error = unexpectedError;
            }
            return NO;
        } else {
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
            if (status != errSecSuccess) {
                if (error) {
                    *error = [self.class securityError:status];
                }
                return NO;
            }
        }
    } else if (status == errSecItemNotFound) {
        NSError *unexpectedError;
        NSMutableDictionary *attributes = [self attributesWithKey:key value:data error:&unexpectedError];
        
        if (label) {
            attributes[(__bridge __strong id)kSecAttrLabel] = label;
        }
        if (comment) {
            attributes[(__bridge __strong id)kSecAttrComment] = comment;
        }
        
        if (unexpectedError) {
            if (error) {
                *error = unexpectedError;
            }
            return NO;
        } else {
            status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
            if (status != errSecSuccess) {
                if (error) {
                    *error = [self.class securityError:status];
                }
                return NO;
            }
        }
    } else {
        if (error) {
            *error = [self.class securityError:status];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark -

+ (BOOL)removeItemForKey:(NSString *)key
{
    return [self removeItemForKey:key service:nil accessGroup:nil error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key service:nil accessGroup:nil error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service
{
    return [self removeItemForKey:key service:service accessGroup:nil error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self removeItemForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [self.class argumentError:NSLocalizedString(@"the key must not to be nil", nil)];
        }
        return NO;
    }
    if (!service) {
        service = [self defaultService];
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
    return [keychain removeItemForKey:key error:error];
}

#pragma mark -

+ (BOOL)removeAllItems
{
    return [self removeAllItemsForService:nil accessGroup:nil error:nil];
}

+ (BOOL)removeAllItemsWithError:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsForService:nil accessGroup:nil error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service
{
    return [self removeAllItemsForService:service accessGroup:nil error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsForService:service accessGroup:nil error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self removeAllItemsForService:service accessGroup:accessGroup error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
    return [keychain removeAllItemsWithError:error];
}

#pragma mark -

- (BOOL)removeItemForKey:(NSString *)key
{
    return [self removeItemForKey:key error:nil];
}

- (BOOL)removeItemForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *query = [self query];
    query[(__bridge __strong id)kSecAttrAccount] = key;
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        if (error) {
            *error = [self.class securityError:status];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (BOOL)removeAllItems
{
    return [self removeAllItemsWithError:nil];
}

- (BOOL)removeAllItemsWithError:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *query = [self query];
#if !TARGET_OS_IPHONE
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
#endif
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        if (error) {
            *error = [self.class securityError:status];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (NSString *)objectForKeyedSubscript:(NSString <NSCopying> *)key
{
    return [self stringForKey:key];
}

- (void)setObject:(NSString *)obj forKeyedSubscript:(NSString <NSCopying> *)key
{
    if (!obj) {
        [self removeItemForKey:key];
    } else {
        [self setString:obj forKey:key];
    }
}

#pragma mark -

- (NSArray *)allKeys
{
    return [self.class allKeysWithItemClass:[self itemClassObject]];
}

+ (NSArray *)allKeysWithItemClass:(CFTypeRef)itemClass
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    query[(__bridge __strong id)kSecClass] = (__bridge id)itemClass;
    query[(__bridge __strong id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge __strong id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef *)&result);
    
    if (status == errSecSuccess) {
        NSArray *items = [self prettify:itemClass items:(__bridge NSArray *)result];
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        for (NSDictionary *item in items) {
            if (itemClass == kSecClassGenericPassword) {
                [keys addObject:@{@"service": item[@"service"] ?: @"", @"key": item[@"key"] ?: @""}];
            } else if (itemClass == kSecClassInternetPassword) {
                [keys addObject:@{@"server": item[@"service"] ?: @"", @"key": item[@"key"] ?: @""}];
            }
        }
    } else if (status == errSecItemNotFound) {
        return @[];
    }
    
    return nil;
}

+ (NSArray *)allItemsWithItemClass:(CFTypeRef)itemClass
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    query[(__bridge __strong id)kSecClass] = (__bridge id)itemClass;
    query[(__bridge __strong id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge __strong id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
#if !TARGET_OS_IPHONE
    query[(__bridge __strong id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
#endif
    
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef *)&result);
    
    if (status == errSecSuccess) {
        return [self prettify:itemClass items:(__bridge NSArray *)result];
    } else if (status == errSecItemNotFound) {
        return @[];
    }
    
    return nil;
}

- (NSArray *)allItems
{
    return [self.class allItemsWithItemClass:[self itemClassObject]];
}

- (NSArray *)items
{
    NSMutableDictionary *query = [self query];
    query[(__bridge __strong id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge __strong id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
#if !TARGET_OS_IPHONE
    query[(__bridge __strong id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
#endif
    
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef *)&result);
    
    if (status == errSecSuccess) {
        return CFBridgingRelease(result);
    } else if (status == errSecItemNotFound) {
        return @[];
    }
    
    return nil;
}

+ (NSArray *)prettify:(CFTypeRef)itemClass items:(NSArray *)items
{
    NSMutableArray *prettified = [[NSMutableArray alloc] init];
    
    for (NSDictionary *attributes in items) {
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        if (itemClass == kSecClassGenericPassword) {
            item[@"class"] = @"GenericPassword";
            id service = attributes[(__bridge id)kSecAttrService];
            if (service) {
                item[@"service"] = service;
            }
            id accessGroup = attributes[(__bridge id)kSecAttrAccessGroup];
            if (service) {
                item[@"accessGroup"] = accessGroup;
            }
        } else if (itemClass == kSecClassInternetPassword) {
            item[@"class"] = @"InternetPassword";
            id server = attributes[(__bridge id)kSecAttrServer];
            if (server) {
                item[@"server"] = server;
            }
            id protocolType = attributes[(__bridge id)kSecAttrProtocol];
            if (protocolType) {
                item[@"protocol"] = protocolType;
            }
            id authenticationType = attributes[(__bridge id)kSecAttrAuthenticationType];
            if (authenticationType) {
                item[@"authenticationType"] = authenticationType;
            }
        }
        id key = attributes[(__bridge id)kSecAttrAccount];
        if (key) {
            item[@"key"] = key;
        }
        NSData *data = attributes[(__bridge id)kSecValueData];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            item[@"value"] = string;
        } else {
            item[@"value"] = data;
        }
        
        id accessible = attributes[(__bridge id)kSecAttrAccessible];
        if (accessible) {
            item[@"accessibility"] = accessible;
        }
        id synchronizable = attributes[(__bridge id)kSecAttrSynchronizable];
        if (synchronizable) {
            item[@"synchronizable"] = synchronizable;
        }
        
        [prettified addObject:item];
    }
    
    return prettified.copy;
}

#pragma mark -

- (void)setAccessibility:(UICKeyChainStoreAccessibility)accessibility authenticationPolicy:(UICKeyChainStoreAuthenticationPolicy)authenticationPolicy
{
    _accessibility = accessibility;
    _authenticationPolicy = authenticationPolicy;
}

#pragma mark -

- (void)synchronize
{
    // Deprecated, calling this method is no longer required
}

- (BOOL)synchronizeWithError:(NSError *__autoreleasing *)error
{
    // Deprecated, calling this method is no longer required
    return true;
}

#pragma mark -

- (NSString *)description
{
    NSArray *items = [self allItems];
    if (items.count == 0) {
        return @"()";
    }
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"(\n"];
    for (NSDictionary *item in items) {
        [description appendFormat:@"    %@", item];
    }
    [description appendString:@")"];
    return description.copy;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@", [self items]];
}

#pragma mark -

- (NSMutableDictionary *)query
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    
    CFTypeRef itemClass = [self itemClassObject];
    query[(__bridge __strong id)kSecClass] =(__bridge id)itemClass;
    query[(__bridge __strong id)kSecAttrSynchronizable] = (__bridge id)kSecAttrSynchronizableAny;
    
    if (itemClass == kSecClassGenericPassword) {
        query[(__bridge __strong id)(kSecAttrService)] = _service;
#if !TARGET_IPHONE_SIMULATOR
        if (_accessGroup) {
            query[(__bridge __strong id)kSecAttrAccessGroup] = _accessGroup;
        }
#endif
    } else {
        if (_server.host) {
            query[(__bridge __strong id)kSecAttrServer] = _server.host;
        }
        if (_server.port) {
            query[(__bridge __strong id)kSecAttrPort] = _server.port;
        }
        CFTypeRef protocolTypeObject = [self protocolTypeObject];
        if (protocolTypeObject) {
            query[(__bridge __strong id)kSecAttrProtocol] = (__bridge id)protocolTypeObject;
        }
        CFTypeRef authenticationTypeObject = [self authenticationTypeObject];
        if (authenticationTypeObject) {
            query[(__bridge __strong id)kSecAttrAuthenticationType] = (__bridge id)authenticationTypeObject;
        }
    }
    
#if TARGET_OS_IPHONE
    if (_authenticationPrompt) {
        if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+
            query[(__bridge __strong id)kSecUseOperationPrompt] = _authenticationPrompt;
        } else {
            NSLog(@"%@", @"Unavailable 'authenticationPrompt' attribute on iOS versions prior to 8.0.");
        }
    }
#endif
    
    return query;
}

- (NSMutableDictionary *)attributesWithKey:(NSString *)key value:(NSData *)value error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *attributes;
    
    if (key) {
        attributes = [self query];
        attributes[(__bridge __strong id)kSecAttrAccount] = key;
    } else {
        attributes = [[NSMutableDictionary alloc] init];
    }
    
    attributes[(__bridge __strong id)kSecValueData] = value;
    
#if TARGET_OS_IPHONE
    double iOS_7_1_or_10_9_2 = 1047.25; // NSFoundationVersionNumber_iOS_7_1
#else
    double iOS_7_1_or_10_9_2 = 1056.13; // NSFoundationVersionNumber10_9_2
#endif
    CFTypeRef accessibilityObject = [self accessibilityObject];
    if (_authenticationPolicy && accessibilityObject) {
        if (floor(NSFoundationVersionNumber) > floor(iOS_7_1_or_10_9_2)) { // iOS 8+ or OS X 10.10+
            CFErrorRef securityError;
            SecAccessControlRef accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibilityObject, (SecAccessControlCreateFlags)_authenticationPolicy, &securityError);
            if (securityError) {
                if (error) {
                    *error = (__bridge NSError *)securityError;
                    return nil;
                }
            }
            if (!accessControl) {
                if (error) {
                    NSString *message = @"Unexpected error has occurred.";
                    *error = [self.class unexpectedError:message];
                    return nil;
                }
            }
            attributes[(__bridge __strong id)kSecAttrAccessControl] = (__bridge id)accessControl;
        } else {
#if TARGET_OS_IPHONE
            NSLog(@"%@", @"Unavailable 'Touch ID integration' on iOS versions prior to 8.0.");
#else
            NSLog(@"%@", @"Unavailable 'Touch ID integration' on OS X versions prior to 10.10.");
#endif
        }
    } else {
        if (floor(NSFoundationVersionNumber) <= floor(iOS_7_1_or_10_9_2) && _accessibility == UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly) {
#if TARGET_OS_IPHONE
            NSLog(@"%@", @"Unavailable 'UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly' attribute on iOS versions prior to 8.0.");
#else
            NSLog(@"%@", @"Unavailable 'UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly' attribute on OS X versions prior to 10.10.");
#endif
        } else {
            if (accessibilityObject) {
                attributes[(__bridge __strong id)kSecAttrAccessible] = (__bridge id)accessibilityObject;
            }
        }
    }
    
    attributes[(__bridge __strong id)kSecAttrSynchronizable] = @(_synchronizable);
    
    return attributes;
}

#pragma mark -

- (CFTypeRef)itemClassObject
{
    switch (_itemClass) {
        case UICKeyChainStoreItemClassGenericPassword:
            return kSecClassGenericPassword;
        case UICKeyChainStoreItemClassInternetPassword:
            return kSecClassInternetPassword;
        default:
            return nil;
    }
}

- (CFTypeRef)protocolTypeObject
{
    switch (_protocolType) {
        case UICKeyChainStoreProtocolTypeFTP:
            return kSecAttrProtocolFTP;
        case UICKeyChainStoreProtocolTypeFTPAccount:
            return kSecAttrProtocolFTPAccount;
        case UICKeyChainStoreProtocolTypeHTTP:
            return kSecAttrProtocolHTTP;
        case UICKeyChainStoreProtocolTypeIRC:
            return kSecAttrProtocolIRC;
        case UICKeyChainStoreProtocolTypeNNTP:
            return kSecAttrProtocolNNTP;
        case UICKeyChainStoreProtocolTypePOP3:
            return kSecAttrProtocolPOP3;
        case UICKeyChainStoreProtocolTypeSMTP:
            return kSecAttrProtocolSMTP;
        case UICKeyChainStoreProtocolTypeSOCKS:
            return kSecAttrProtocolSOCKS;
        case UICKeyChainStoreProtocolTypeIMAP:
            return kSecAttrProtocolIMAP;
        case UICKeyChainStoreProtocolTypeLDAP:
            return kSecAttrProtocolLDAP;
        case UICKeyChainStoreProtocolTypeAppleTalk:
            return kSecAttrProtocolAppleTalk;
        case UICKeyChainStoreProtocolTypeAFP:
            return kSecAttrProtocolAFP;
        case UICKeyChainStoreProtocolTypeTelnet:
            return kSecAttrProtocolTelnet;
        case UICKeyChainStoreProtocolTypeSSH:
            return kSecAttrProtocolSSH;
        case UICKeyChainStoreProtocolTypeFTPS:
            return kSecAttrProtocolFTPS;
        case UICKeyChainStoreProtocolTypeHTTPS:
            return kSecAttrProtocolHTTPS;
        case UICKeyChainStoreProtocolTypeHTTPProxy:
            return kSecAttrProtocolHTTPProxy;
        case UICKeyChainStoreProtocolTypeHTTPSProxy:
            return kSecAttrProtocolHTTPSProxy;
        case UICKeyChainStoreProtocolTypeFTPProxy:
            return kSecAttrProtocolFTPProxy;
        case UICKeyChainStoreProtocolTypeSMB:
            return kSecAttrProtocolSMB;
        case UICKeyChainStoreProtocolTypeRTSP:
            return kSecAttrProtocolRTSP;
        case UICKeyChainStoreProtocolTypeRTSPProxy:
            return kSecAttrProtocolRTSPProxy;
        case UICKeyChainStoreProtocolTypeDAAP:
            return kSecAttrProtocolDAAP;
        case UICKeyChainStoreProtocolTypeEPPC:
            return kSecAttrProtocolEPPC;
        case UICKeyChainStoreProtocolTypeNNTPS:
            return kSecAttrProtocolNNTPS;
        case UICKeyChainStoreProtocolTypeLDAPS:
            return kSecAttrProtocolLDAPS;
        case UICKeyChainStoreProtocolTypeTelnetS:
            return kSecAttrProtocolTelnetS;
        case UICKeyChainStoreProtocolTypeIRCS:
            return kSecAttrProtocolIRCS;
        case UICKeyChainStoreProtocolTypePOP3S:
            return kSecAttrProtocolPOP3S;
        default:
            return nil;
    }
}

- (CFTypeRef)authenticationTypeObject
{
    switch (_authenticationType) {
        case UICKeyChainStoreAuthenticationTypeNTLM:
            return kSecAttrAuthenticationTypeNTLM;
        case UICKeyChainStoreAuthenticationTypeMSN:
            return kSecAttrAuthenticationTypeMSN;
        case UICKeyChainStoreAuthenticationTypeDPA:
            return kSecAttrAuthenticationTypeDPA;
        case UICKeyChainStoreAuthenticationTypeRPA:
            return kSecAttrAuthenticationTypeRPA;
        case UICKeyChainStoreAuthenticationTypeHTTPBasic:
            return kSecAttrAuthenticationTypeHTTPBasic;
        case UICKeyChainStoreAuthenticationTypeHTTPDigest:
            return kSecAttrAuthenticationTypeHTTPDigest;
        case UICKeyChainStoreAuthenticationTypeHTMLForm:
            return kSecAttrAuthenticationTypeHTMLForm;
        case UICKeyChainStoreAuthenticationTypeDefault:
            return kSecAttrAuthenticationTypeDefault;
        default:
            return nil;
    }
}

- (CFTypeRef)accessibilityObject
{
    switch (_accessibility) {
        case UICKeyChainStoreAccessibilityWhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked;
        case UICKeyChainStoreAccessibilityAfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock;
        case UICKeyChainStoreAccessibilityAlways:
            return kSecAttrAccessibleAlways;
        case UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
        case UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
        case UICKeyChainStoreAccessibilityAfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
        case UICKeyChainStoreAccessibilityAlwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly;
        default:
            return nil;
    }
}

+ (NSError *)argumentError:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:UICKeyChainStoreErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey: message}];
    NSLog(@"error: [%@] %@", @(error.code), error.localizedDescription);
    return error;
}

+ (NSError *)conversionError:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:-67594 userInfo:@{NSLocalizedDescriptionKey: message}];
    NSLog(@"error: [%@] %@", @(error.code), error.localizedDescription);
    return error;
}

+ (NSError *)securityError:(OSStatus)status
{
    NSError *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: @"Security error has occurred."}];
    NSLog(@"OSStatus error: [%@] %@", @(error.code), error.localizedDescription);
    return error;
}

+ (NSError *)unexpectedError:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:-99999 userInfo:@{NSLocalizedDescriptionKey: message}];
    NSLog(@"error: [%@] %@", @(error.code), error.localizedDescription);
    return error;
}

@end
