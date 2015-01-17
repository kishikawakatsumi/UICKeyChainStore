# UICKeyChainStore
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/UICKeyChainStore.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/UICKeyChainStore)
[![Coverage Status](https://img.shields.io/coveralls/kishikawakatsumi/UICKeyChainStore.svg?style=flat)](https://coveralls.io/r/kishikawakatsumi/UICKeyChainStore?branch=master)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)
[![License](https://img.shields.io/cocoapods/l/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)
[![Platform](https://img.shields.io/cocoapods/p/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)

UICKeyChainStore is a simple wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults.

## Looking for the library written in Swift?

Try [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess).  
[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) is next generation of UICKeyChainStore.

## Transitioning from 1.x to 2.0

**`synchronize` method is deprecated. Calling this method is no longer required (Just ignored).**

## :bulb: Features

- Simple interface
- Support access group
- [Support accessibility](#accessibility)
- [Support iCloud sharing](#icloud_sharing)
- **[Support TouchID and Keychain integration (iOS 8+)](#touch_id_integration)**
- Works on both iOS & OS X

## :book: Usage

### :key: Basics

#### Saving Application Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef";
```

#### Saving Internet Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef";
```

### :key: Instantiation

#### Create Keychain for Application Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
```

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"kishikawakatsumi.git"
                                                            accessGroup:@"12ABCD3E4F.shared"];
```

#### Create Keychain for Internet Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
```

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS
                                                    authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
```

### :key: Adding an item

#### subscripting

```objective-c
keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

#### set method

```objective-c
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
```

#### error handling

```objective-c
if (![keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"]) {
    // error has occurred
}
```

```objective-c
NSError *error;
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### :key: Obtaining an item

#### subscripting (automatically converts to string)

```objective-c
NSString *token = keychain["kishikawakatsumi"]
```

#### get methods

##### as String

```objective-c
NSString *token = [keychain stringForKey:@"kishikawakatsumi"];
```

##### as NSData

```objective-c
NSData *data = [keychain dataForKey:@"kishikawakatsumi"];
```

#### error handling

**First, get the `failable` (value or error) object**

```objective-c
NSError *error;
NSString *token = [keychain stringForKey:@"" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### :key: Removing an item

#### subscripting

```objective-c
keychain["kishikawakatsumi"] = nil
```

#### remove method

```objective-c
[keychain removeItemForKey:@"kishikawakatsumi"];
```

#### error handling

```objective-c
if (![keychain removeItemForKey:@"kishikawakatsumi"]) {
    // error has occurred
}
```

```objective-c
NSError *error;
[keychain removeItemForKey:@"kishikawakatsumi" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### :key: Label and Comment

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef"
             forKey:@"kishikawakatsumi"
              label:@"github.com (kishikawakatsumi)"
            comment:@"github access token"];
```

### :key: Configuration (Accessibility, Sharing, iCould Sync)

#### <a name="accessibility"> Accessibility

##### Default accessibility matches background application (=kSecAttrAccessibleAfterFirstUnlock)

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
```

##### For background application

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.accessibility = UICKeyChainStoreAccessibilityAfterFirstUnlock;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

##### For foreground application

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

#### :couple: Sharing Keychain items

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"kishikawakatsumi.git"
                                                            accessGroup:@"12ABCD3E4F.shared"];
```

#### <a name="icloud_sharing"> :arrows_counterclockwise: Synchronizing Keychain items with iCloud

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.synchronizable = YES;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

### <a name="touch_id_integration"> :fu: Touch ID integration

**Any Operation that require authentication must be run in the background thread.**  
**If you run in the main thread, UI thread will lock for the system to try to display the authentication dialog.**

#### :closed_lock_with_key: Adding a Touch ID protected item

If you want to store the Touch ID protected Keychain item, specify `accessibility` and `authenticationPolicy` attributes.  

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];

    keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
});
```

#### :closed_lock_with_key: Updating a Touch ID protected item

The same way as when adding.  

**Do not run in the main thread if there is a possibility that the item you are trying to add already exists, and protected.**
**Because updating protected items requires authentication.**

Additionally, you want to show custom authentication prompt message when updating, specify an `authenticationPrompt` attribute.
If the item not protected, the `authenticationPrompt` parameter just be ignored.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
    keychain.authenticationPrompt = @"Authenticate to update your access token";

    keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
});
```

#### :closed_lock_with_key: Obtaining a Touch ID protected item

The same way as when you get a normal item. It will be displayed automatically Touch ID or passcode authentication If the item you try to get is protected.  
If you want to show custom authentication prompt message, specify an `authenticationPrompt` attribute.
If the item not protected, the `authenticationPrompt` parameter just be ignored.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
    keychain.authenticationPrompt = @"Authenticate to update your access token";

    NSString *token = keychain[@"kishikawakatsumi"];
});
```

#### :closed_lock_with_key: Removing a Touch ID protected item

The same way as when you remove a normal item.
There is no way to show Touch ID or passcode authentication when removing Keychain items.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

keychain[@"kishikawakatsumi"] = nil;
```

### :key: Debugging

#### Display all stored items if print keychain object

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
NSLog(@"%@", keychain);
```

```
=>
(
{
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = kishikawakatsumi;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "01234567-89ab-cdef-0123-456789abcdef";
}    {
    accessibility = ck;
    authenticationType = dflt;
    class = InternetPassword;
    key = hirohamada;
    protocol = htps;
    server = "github.com";
    synchronizable = 1;
    value = "11111111-89ab-cdef-1111-456789abcdef";
}    {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = honeylemon;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "22222222-89ab-cdef-2222-456789abcdef";
})
```

#### Obtaining all stored keys

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];

NSArray *keys = keychain.allKeys;
for (NSString *key in keys) {
    NSLog(@"key: %@", key);
}
```

```
=>
key: kishikawakatsumi
key: hirohamada
key: honeylemon
```

#### Obtaining all stored items

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];

NSArray *items = keychain.allItems;
for (NSString *item in items) {
    NSLog(@"item: %@", item);
}
```

```
=>

item: {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = kishikawakatsumi;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "01234567-89ab-cdef-0123-456789abcdef";
}
item: {
    accessibility = ck;
    authenticationType = dflt;
    class = InternetPassword;
    key = hirohamada;
    protocol = htps;
    server = "github.com";
    synchronizable = 1;
    value = "11111111-89ab-cdef-1111-456789abcdef";
}
item: {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = honeylemon;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "22222222-89ab-cdef-2222-456789abcdef";
}
```

### Convienient class methods

Add items using default service name (=bundle identifer).

```objective-c
[UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
```

Or specify the service name.

```objective-c
[UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef"
                     forKey:@"kishikawakatsumi"
                    service:@"com.example.github-token"];
```

---
Remove items.

```objective-c
[UICKeyChainStore removeItemForKey:@"kishikawakatsumi" service:@"com.example.github-token"];
```

To set nil value also works remove item for the key.

```objective-c
[UICKeyChainStore setString:nil forKey:@"kishikawakatsumi" service:@"com.example.github-token"];
```

## Requirements

iOS 4.3 or later
OS X 10.7 or later

## Installation

### CocoaPods

UICKeyChainStore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`pod 'UICKeyChainStore'`

### Carthage

UICKeyChainStore is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

`github "kishikawakatsumi/UICKeyChainStore"`

### To manually add to your project

1. Add `Security.framework` to your target.
2. Copy files in Lib (`UICKeyChainStore.h` and `UICKeyChainStore.m`) to your project.

## Author

kishikawa katsumi, kishikawakatsumi@mac.com

## License

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
[GPL]: http://www.gnu.org/licenses/gpl.html
[BSD]: http://opensource.org/licenses/bsd-license.php

UICKeyChainStore is available under the [MIT license][MIT]. See the LICENSE file for more info.
