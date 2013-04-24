//
//  UICKeyChainStore.m
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UICKeyChainStore.h"

static NSString *defaultService;

@interface UICKeyChainStore () {
    NSMutableDictionary *itemsToUpdate;
}

@end

@implementation UICKeyChainStore

@synthesize service;
@synthesize accessGroup;

+ (void)initialize
{
    defaultService = [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key service:defaultService accessGroup:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service
{
    return [self stringForKey:key service:service accessGroup:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    NSData *data = [self dataForKey:key service:service accessGroup:accessGroup];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [self setString:value forKey:key service:defaultService accessGroup:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service
{
    return [self setString:value forKey:key service:service accessGroup:nil];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [self setData:data forKey:key service:service accessGroup:accessGroup];
}

+ (NSData *)dataForKey:(NSString *)key
{
    return [self dataForKey:key service:defaultService accessGroup:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service
{
    return [self dataForKey:key service:service accessGroup:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
	if (!key) {
        NSAssert(NO, @"key must not be nil.");
		return nil;
	}
	if (!service) {
        service = defaultService;
	}
    
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
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
    
	CFTypeRef data = nil;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
	if (status != errSecSuccess) {
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
    return [self setData:data forKey:key service:defaultService accessGroup:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service
{
    return [self setData:data forKey:key service:service accessGroup:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
	if (!key) {
        NSAssert(NO, @"The `key` must not be nil.");
		return NO;
	}
	if (!service) {
        service = defaultService;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:service forKey:(__bridge id)kSecAttrService];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	if (status == errSecSuccess) {
        if (data) {
            NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
            [attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];
            
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
            if (status != errSecSuccess) {
                return NO;
            }
        } else {
            [self removeItemForKey:key service:service accessGroup:accessGroup];
        }
	} else if (status == errSecItemNotFound) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		[attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [attributes setObject:service forKey:(__bridge id)kSecAttrService];
        [attributes setObject:key forKey:(__bridge id)kSecAttrGeneric];
        [attributes setObject:key forKey:(__bridge id)kSecAttrAccount];
		[attributes setObject:data forKey:(__bridge id)kSecValueData];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        if (accessGroup) {
            [attributes setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
#endif
		
		status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
		if (status != errSecSuccess) {
			return NO;
		}		
	} else {
        return NO;
	}
    
    return YES;
}

+ (BOOL)removeItemForKey:(NSString *)key
{
    return [UICKeyChainStore removeItemForKey:key service:defaultService accessGroup:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service
{
    return [UICKeyChainStore removeItemForKey:key service:service accessGroup:nil];
}

+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
{
	if (!key) {
        NSAssert(NO, @"The `key` must not be nil.");
		return NO;
	}
	if (!service) {
        service = defaultService;
	}
	
	NSMutableDictionary *itemToDelete = [NSMutableDictionary dictionary];
	[itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[itemToDelete setObject:service forKey:(__bridge id)kSecAttrService];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [itemToDelete setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
	
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)itemToDelete);
	if (status != errSecSuccess && status != errSecItemNotFound) {
        return NO;
	}
    
    return YES;
}

+ (NSArray *)itemsForService:(NSString *)service accessGroup:(NSString *)accessGroup
{
	if (!service) {
        service = defaultService;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
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
	
	CFArrayRef result = nil;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
	if (status == errSecSuccess || status == errSecItemNotFound) {
		return (__bridge NSArray *)result;
	} else {
		return nil;
	}
}

+ (BOOL)removeAllItems
{
    return [self removeAllItemsForService:defaultService accessGroup:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service
{
    return [self removeAllItemsForService:service accessGroup:nil];
}

+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    NSArray *items = [UICKeyChainStore itemsForService:service accessGroup:accessGroup];    
    for (NSDictionary *item in items) {
        NSMutableDictionary *itemToDelete = [NSMutableDictionary dictionaryWithDictionary:item];
        [itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)itemToDelete);
        if (status != errSecSuccess) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -

+ (UICKeyChainStore *)keyChainStore
{
    return [[self alloc] initWithService:defaultService];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service
{
    return [[self alloc] initWithService:service];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
    return [[self alloc] initWithService:service accessGroup:accessGroup];
}

- (id)init
{
    return [self initWithService:defaultService accessGroup:nil];
}

- (id)initWithService:(NSString *)s
{
    return [self initWithService:s accessGroup:nil];
}

- (id)initWithService:(NSString *)s accessGroup:(NSString *)group
{
    self = [super init];
    if (self) {
        if (!s) {
            s = defaultService;
        }
        service = [s copy];
        accessGroup = [group copy];
        if (accessGroup) {
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
            [itemsToUpdate setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
        }
		
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:itemsToUpdate];
        [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
        [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
        
        CFTypeRef result = nil;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        if (status == errSecSuccess) {
            itemsToUpdate = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)result];
		} else {
            itemsToUpdate = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

#pragma mark -

- (NSString *)description
{
    NSArray *items = [UICKeyChainStore itemsForService:service accessGroup:accessGroup];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:[items count]];    
    for (NSDictionary *attributes in items) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
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

#pragma mark -

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
}

- (NSString *)stringForKey:(id)key
{
    NSData *data = [self dataForKey:key];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)setData:(NSData *)data forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    if (!data) {
        [self removeItemForKey:key];
    } else {
        [itemsToUpdate setObject:data forKey:key];
    }
}

- (NSData *)dataForKey:(NSString *)key
{
    NSData *data = [itemsToUpdate objectForKey:key];
    if (!data) {
        data = [[self class] dataForKey:key service:service accessGroup:accessGroup];
    }
    return data;
}

- (void)removeItemForKey:(NSString *)key
{
    if ([itemsToUpdate objectForKey:key]) {
        [itemsToUpdate removeObjectForKey:key];
    } else {
        [[self class] removeItemForKey:key service:service accessGroup:accessGroup];
    }
}

#pragma mark -

- (void)removeAllItems
{
    [itemsToUpdate removeAllObjects];
    [[self class] removeAllItemsForService:service accessGroup:accessGroup];
}

#pragma mark -

- (void)synchronize
{
    for (NSString *key in itemsToUpdate) {
        [[self class] setData:[itemsToUpdate objectForKey:key] forKey:key service:service accessGroup:accessGroup];
    }
}

@end
