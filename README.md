# UICKeyChainStore

![version](http://cocoapod-badges.herokuapp.com/v/UICKeyChainStore/badge.svg)&nbsp;
![platform](http://cocoapod-badges.herokuapp.com/p/UICKeyChainStore/badge.svg)&nbsp;
[![Build Status](https://travis-ci.org/kishikawakatsumi/UICKeyChainStore.png?branch=master)](https://travis-ci.org/kishikawakatsumi/UICKeyChainStore)
[![Coverage Status](https://coveralls.io/repos/kishikawakatsumi/UICKeyChainStore/badge.png?branch=master)](https://coveralls.io/r/kishikawakatsumi/UICKeyChainStore?branch=master)


UICKeyChainStore is a simple wrapper for Keychain on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults.

## License
MIT License

## Installation
### CocoaPods
`pod 'UICKeyChainStore'`

### Manual Install
1. Add `Security.framework` to your target.
2. Copy files in Lib (`UICKeyChainStore.h` and `UICKeyChainStore.m`) to your project.

## Usage

### Using convienient class methods

Add items using default service name (=bundle identifer).

```objective-c
[UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
[UICKeyChainStore setString:@"password1234" forKey:@"password"];

//=> ["username" = "kishikawakatsumi", "password" = "password1234"]
```

Or specify the service name.

```objective-c
[UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"com.kishikawakatsumi"];
[UICKeyChainStore setString:@"password1234" forKey:@"password" service:@"com.kishikawakatsumi"];
```

---
Remove items.

```objective-c
[UICKeyChainStore removeItemForKey:@"username" service:@"com.kishikawakatsumi"];
[UICKeyChainStore removeItemForKey:@"password" service:@"com.kishikawakatsumi"];
```

=====
### Using store object, easier to edit multiple items

Instantiate store object with default service name.

```objective-c
UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
```

Or specify the service name.

```objective-c
UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"com.kishikawakatsumi"];
```

Add items and save.

```objective-c
[store setString:@"kishikawakatsumi@mac.com" forKey:@"username"];
[store setString:@"password1234" forKey:@"password"];

[store synchronize]; // Write to keychain.
```

Remove items.

```objective-c
[store removeItemForKey:@"username"];
[store removeItemForKey:@"password"];

[store synchronize]; // Write to keychain.
```

---
### Debug print

```objective-c
UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"com.kishikawakatsumi"];
NSLog(@"%@", store); // Print all keys and values for the service.
```

---
Easy as that. (See [UICKeyChainStore.h](https://github.com/kishikawakatsumi/UICKeyChainStore/blob/master/Lib/UICKeyChainStore.h) for all of the methods.)
