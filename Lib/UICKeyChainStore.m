//
//  UICKeyChainStore.m
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UICKeyChainStore.h"
#import "UICKeyChainItem.h"

NSString * const UICKeyChainStoreErrorDomain = @"com.kishikawakatsumi.uickeychainstore";
static NSString *_defaultService;
static CFTypeRef _defaultAccessibility;

@interface UICKeyChainStore () {
    NSMutableDictionary *itemsToUpdate;
}

@end

@implementation UICKeyChainStore

+ (NSString *)defaultService
{
    if (!_defaultService) {
        _defaultService = [[NSBundle mainBundle] bundleIdentifier];
    }
    
    return _defaultService;
}

+ (void)setDefaultService:(NSString *)defaultService
{
    _defaultService = defaultService;
}

+ (CFTypeRef)defaultAccessibility
{
    if (!_defaultAccessibility) {
        _defaultAccessibility = kSecAttrAccessibleAfterFirstUnlock;
    }
    return _defaultAccessibility;
}

+ (void)setDefaultAccessibility:(CFTypeRef)defaultAccessibility
{
    _defaultAccessibility = defaultAccessibility;
}

#pragma mark -

+ (UICKeyChainStore *)keyChainStore
{
    return [[self alloc] initWithService:[self defaultService]];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service
{
    return [[self alloc] initWithService:service];
}

+ (UICKeyChainStore *)keyChainStoreWithAccessibility:(CFTypeRef)accessibility
{
    return [[self alloc] initWithAccessibility:accessibility];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [[self alloc] initWithService:service accessibility:accessibility];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [[self alloc] initWithService:service accessGroup:accessGroup];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [[self alloc] initWithService:service accessGroup:accessGroup accessibility:accessibility];
}

- (instancetype)init
{
    return [self initWithService:[self.class defaultService] accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service
{
    return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithAccessibility:(CFTypeRef)accessibility
{
    return [self initWithService:[self.class defaultService] accessibility:accessibility];
}

- (instancetype)initWithService:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self initWithService:service accessGroup:nil accessibility:accessibility];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self initWithService:service accessGroup:accessGroup accessibility:[self.class defaultAccessibility]];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    self = [super init];
    if (self) {
        if (!service) {
            service = [self.class defaultService];
        }
        _service = [service copy];
        _accessGroup = [accessGroup copy];
        _accessibility = accessibility;
        
        itemsToUpdate = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark -

+ (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key error:nil];
}

+ (NSString *)stringForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key service:nil error:error];
}

+ (NSString *)stringForKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self stringForKey:key accessibility:accessibility error:nil];
}

+ (NSString *)stringForKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self stringForKey:key service:nil accessibility:accessibility error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service
{
    return [self stringForKey:key service:service error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key service:service accessGroup:nil error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self stringForKey:key service:service accessibility:accessibility error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self stringForKey:key service:service accessGroup:nil accessibility:accessibility error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self stringForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key service:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self stringForKey:key service:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    NSData *data = [self dataForKey:key service:service accessGroup:accessGroup accessibility:accessibility error:error];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [self setString:value forKey:key error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setString:value forKey:key service:nil error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setString:value forKey:key accessibility:accessibility error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self setString:value forKey:key service:nil accessibility:accessibility error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service
{
    return [self setString:value forKey:key service:service error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self setString:value forKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self setString:value forKey:key service:service accessibility:accessibility error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self setString:value forKey:key service:service accessGroup:nil accessibility:accessibility error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self setString:value forKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self setString:value forKey:key service:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self setString:value forKey:key service:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error;
{
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [self setData:data forKey:key service:service accessGroup:accessGroup accessibility:accessibility error:error];
}

#pragma mark -

+ (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key error:nil];
}

+ (NSData *)dataForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key service:nil error:error];
}

+ (NSData *)dataForKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self dataForKey:key accessibility:accessibility error:nil];
}

+ (NSData *)dataForKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{  
    return [self dataForKey:key service:nil accessibility:accessibility error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service
{
    return [self dataForKey:key service:service error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key service:service accessGroup:nil error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self dataForKey:key service:service accessibility:accessibility error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self dataForKey:key service:service accessGroup:nil accessibility:accessibility error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self dataForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key service:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self dataForKey:key service:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:UICKeyChainStoreErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"`key` must not to be nil", nil)}];
        }
        return nil;
    }
    if (!service) {
        service = [self defaultService];
    }
    if (!accessibility) {
        accessibility = [self defaultAccessibility];
    }
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
    [query setObject:(__bridge id)accessibility forKey:(__bridge id)kSecAttrAccessible];
#endif
    
    CFTypeRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    if (status != errSecSuccess) {
        if (status != errSecItemNotFound) {
            if (error) {
                *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
            }
        }
        return nil;
    }
    
    NSData *ret = [NSData dataWithData:(__bridge NSData *)data];
    if (data) {
        CFRelease(data);
    }
    
    return ret;
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key
{
    return [self setData:data forKey:key error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key service:nil error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setData:data forKey:key accessibility:accessibility error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self setData:data forKey:key service:nil accessibility:accessibility error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service
{
    return [self setData:data forKey:key service:service error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self setData:data forKey:key service:service accessibility:accessibility error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self setData:data forKey:key service:service accessGroup:nil accessibility:accessibility error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self setData:data forKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self setData:data forKey:key service:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self setData:data forKey:key service:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error;
{
    if (!key) {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:UICKeyChainStoreErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"`key` must not to be nil", nil)}];
        }
        return NO;
    }
    if (!service) {
        service = [self defaultService];
    }
    if (!accessibility) {
        accessibility = [self defaultAccessibility];
    }
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
    [query setObject:(__bridge id)accessibility forKey:(__bridge id)kSecAttrAccessible];
#endif

#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecSuccess) {
        if (data) {
            NSMutableDictionary *attributesToUpdate = [[NSMutableDictionary alloc] init];
            [attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];
            
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
            if (status != errSecSuccess) {
                if (error) {
                    *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
                }
                return NO;
            }
        } else {
            [self removeItemForKey:key service:service accessGroup:accessGroup accessibility:accessibility];
        }
    } else if (status == errSecItemNotFound) {
        if (!data) {
            return YES;
        }
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [attributes setObject:service forKey:(__bridge id)kSecAttrService];
        [attributes setObject:key forKey:(__bridge id)kSecAttrGeneric];
        [attributes setObject:key forKey:(__bridge id)kSecAttrAccount];
#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
        [attributes setObject:(__bridge id)accessibility forKey:(__bridge id)kSecAttrAccessible];
#endif
        [attributes setObject:data forKey:(__bridge id)kSecValueData];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        if (accessGroup) {
            [attributes setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
#endif
        
        status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
        if (status != errSecSuccess) {
            if (error) {
                *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
            }
            return NO;
        }
    } else {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key error:nil];
}

- (void)setString:(NSString *)string forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key accessibility:accessibility];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key error:error];
    return error == nil;
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key accessbility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key accessibility:accessibility error:error];
    return error == nil;
}

- (NSString *)stringForKey:(id)key
{
    return [self stringForKey:key error:nil];
}

- (NSString *)stringForKey:(id)key error:(NSError *__autoreleasing *)error
{
    return [self stringForKey:key accessbility:self.accessibility error:error];
}

- (NSString *)stringForKey:(NSString *)key accessbility:(CFTypeRef)accessibility
{
    return [self stringForKey:key accessbility:accessibility error:nil];
}

- (NSString *)stringForKey:(NSString *)key accessbility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    NSData *data = [self dataForKey:key accessibility:accessibility error:error];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

#pragma mark -

- (void)setData:(NSData *)data forKey:(NSString *)key
{
    [self setData:data forKey:key error:nil];
}

- (void)setData:(NSData *)data forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    [self setData:data forKey:key accessibility:accessibility error:nil];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    [self setData:data forKey:key accessibility:self.accessibility error:error];
    return error == nil;
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:UICKeyChainStoreErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"`key` must not to be nil", nil)}];
        }
        return error == nil;
    }
    if (!data) {
        [self removeItemForKey:key error:error];
    } else {
        UICKeyChainItem *item = [[UICKeyChainItem alloc] initWithData:data accessibility:accessibility];
        [itemsToUpdate setObject:item forKey:key];
    }
    return error == nil;
}

- (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key error:nil];
}

- (NSData *)dataForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self dataForKey:key accessibility:self.accessibility error:error];
}

- (NSData *)dataForKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self dataForKey:key accessibility:accessibility error:nil];
}

- (NSData *)dataForKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error

{
    UICKeyChainItem *item = [itemsToUpdate objectForKey:key];
    NSData *data = item.data;
    if (!data) {
        data = [self.class dataForKey:key service:self.service accessGroup:self.accessGroup accessibility:accessibility error:error];
    }
    
    return data;
}

#pragma mark -

+ (BOOL)removeItemForKey:(NSString *)key
{
    return [self removeItemForKey:key error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key service:nil error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self removeItemForKey:key accessibility:accessibility error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self removeItemForKey:key service:nil accessibility:accessibility error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service
{
    return [self removeItemForKey:key service:service error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key service:service accessGroup:nil error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self removeItemForKey:key service:service accessibility:accessibility error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self removeItemForKey:key service:service accessGroup:nil accessibility:accessibility error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self removeItemForKey:key service:service accessGroup:accessGroup error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key service:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self removeItemForKey:key service:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    if (!key) {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:UICKeyChainStoreErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"`key` must not to be nil", nil)}];
        }
        return NO;
    }
    if (!service) {
        service = [self defaultService];
    }
    if (!accessibility) {
        accessibility = [self defaultAccessibility];
    }
    
    NSMutableDictionary *itemToDelete = [[NSMutableDictionary alloc] init];
    [itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [itemToDelete setObject:service forKey:(__bridge id)kSecAttrService];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [itemToDelete setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
    [itemToDelete setObject:(__bridge id)accessibility forKey:(__bridge id)kSecAttrAccessible];
#endif
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)itemToDelete);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        if (error) {
            *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
}

+ (NSArray *)itemsForService:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    if (!service) {
        service = [self defaultService];
    }
    if (!accessibility) {
        accessibility = [self defaultAccessibility];
    }
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
    [query setObject:(__bridge id)accessibility forKey:(__bridge id)kSecAttrAccessible];
#endif

    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return CFBridgingRelease(result);
    } else {
        return nil;
    }
}

+ (BOOL)removeAllItems
{
    return [self removeAllItemsWithError:nil];
}

+ (BOOL)removeAllItemsWithError:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsForService:nil error:error];
}

+ (BOOL)removeAllItemsWithAccessibility:(CFTypeRef)accessibility
{
    return [self removeAllItemsWithAccessibility:accessibility error:nil];
}

+ (BOOL)removeAllItemsWithAccessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self removeAllItemsForService:nil accessibility:accessibility error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service
{
    return [self removeAllItemsForService:service error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service error:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsForService:service accessGroup:nil error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessibility:(CFTypeRef)accessibility
{
    return [self removeAllItemsForService:service accessibility:accessibility error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    return [self removeAllItemsForService:service accessGroup:nil accessibility:accessibility error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    return [self removeAllItemsForService:service accessGroup:accessGroup error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsForService:service accessGroup:accessGroup accessibility:nil error:error];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility
{
    return [self removeAllItemsForService:service accessGroup:accessGroup accessibility:accessibility error:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    NSArray *items = [UICKeyChainStore itemsForService:service accessGroup:accessGroup accessibility:accessibility];
    for (NSDictionary *item in items) {
        NSMutableDictionary *itemToDelete = [[NSMutableDictionary alloc] initWithDictionary:item];
        [itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)itemToDelete);
        if (status != errSecSuccess) {
            if (error) {
                *error = [NSError errorWithDomain:UICKeyChainStoreErrorDomain code:status userInfo:nil];
            }
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -

- (void)removeItemForKey:(NSString *)key
{
    [self removeItemForKey:key error:nil];
}

- (BOOL)removeItemForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    return [self removeItemForKey:key accessibility:self.accessibility error:error];
}

- (void)removeItemForKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    [self removeItemForKey:key accessibility:accessibility error:nil];
}

- (BOOL)removeItemForKey:(NSString *)key accessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    if ([itemsToUpdate objectForKey:key]) {
        [itemsToUpdate removeObjectForKey:key];
    } else {
        [self.class removeItemForKey:key service:self.service accessGroup:self.accessGroup accessibility:accessibility error:error];
    }
    return error == nil;
}

- (void)removeAllItems
{
    [self removeAllItemsWithError:nil];
}

- (BOOL)removeAllItemsWithError:(NSError *__autoreleasing *)error
{
    return [self removeAllItemsWithAccessibility:self.accessibility error:error];
}

- (void)removeAllItemsWithAccessibility:(CFTypeRef)accessibility
{
    [self removeAllItemsWithAccessibility:accessibility error:nil];
}

- (BOOL)removeAllItemsWithAccessibility:(CFTypeRef)accessibility error:(NSError * __autoreleasing *)error
{
    [itemsToUpdate removeAllObjects];
    return [self.class removeAllItemsForService:self.service accessGroup:self.accessGroup accessibility:accessibility error:error];
}


#pragma mark -

- (void)synchronize
{
    for (NSString *key in itemsToUpdate) {
        UICKeyChainItem *item = [itemsToUpdate objectForKey:key];
        [self.class setData:item.data forKey:key service:self.service accessGroup:self.accessGroup accessibility:item.accessibility error:nil];
    }
    
    [itemsToUpdate removeAllObjects];
}

- (BOOL)synchronizeWithError:(NSError *__autoreleasing *)error
{
    for (NSString *key in itemsToUpdate) {
        UICKeyChainItem *item = [itemsToUpdate objectForKey:key];
        [self.class setData:item.data forKey:key service:self.service accessGroup:self.accessGroup accessibility:item.accessibility error:error];
    }
    
    [itemsToUpdate removeAllObjects];
    return error == nil;
}

#pragma mark -

- (NSString *)description
{
    NSArray *items = [UICKeyChainStore itemsForService:self.service accessGroup:self.accessGroup accessibility:self.accessibility];
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (NSDictionary *attributes in items) {
        NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrService] forKey:@"Service"];
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrAccount] forKey:@"Account"];
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrAccessGroup] forKey:@"AccessGroup"];
#endif
        NSData *data = [attributes objectForKey:(__bridge id)kSecValueData];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            [attrs setObject:string forKey:@"Value"];
        } else {
            [attrs setObject:data forKey:@"Value"];
        }
        [list addObject:attrs];
    }
    
    return [list description];
}

#pragma mark - Object Subscripting

- (NSString *)objectForKeyedSubscript:(NSString <NSCopying> *)key
{
    return [self stringForKey:key];
}

- (void)setObject:(NSString *)obj forKeyedSubscript:(NSString <NSCopying> *)key
{
    [self setString:obj forKey:key];
}

@end
