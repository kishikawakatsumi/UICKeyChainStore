# UICKeyChainStore

UICKeyChainStore is a simple wrapper for Keychain on iOS. Makes using Keychain APIs as easy as NSUserDefaults.

## Adding to your project

1. Add `Security.framework` to your target
2. Add `UICKeyChainStore.h` and `UICKeyChainStore.m` to your project.

## Usage

###Convienient class methods

Add items using default service name (=bundle identifer).

```objective-c
[UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username"];
[UICKeyChainStore setString:@"password1234" forKey:@"password"];

//=> ["username" = "kishikawakatsumi", "password" = "password1234"]
```

Or specify the service name.

```objective-c
[UICKeyChainStore setString:@"kishikawakatsumi" forKey:@"username" service:@"com.kishikawakatsumi" accessGroup:nil];
[UICKeyChainStore setString:@"katsumi6100" forKey:@"password" service:@"com.kishikawakatsumi" accessGroup:nil];
```

Remove items.

```objective-c
[UICKeyChainStore removeItemForKey:@"username" service:@"com.kishikawakatsumi" accessGroup:nil];
[UICKeyChainStore removeItemForKey:@"password" service:@"com.kishikawakatsumi" accessGroup:nil];
```

###Instantiate store object

```objective-c
UICKeyChainStore *store = [UICKeyChainStore keyChain];
```

or,

```objective-c
UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"com.kishikawakatsumi"];
```

Add items and save.

```objective-c
    [store setString:@"kishikawakatsumi@mac.com" forKey:@"username"];
    [store setString:@"katsumi6100" forKey:@"password"];

    [store synchronize];
```

Remove items.
```objective-c
    [store removeItemForKey:@"username"];
    [store removeItemForKey:@"password"];

    [store synchronize];
```


Easy as that. (See [UICKeyChainStore.h](https://github.com/kishikawakatsumi/UICKeyChainStore/blob/master/UICKeyChainStore.h) for all of the methods.)
