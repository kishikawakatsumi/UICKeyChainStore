//
//  UICKeyChainItem.m
//  
//
//  Created by Bobby Vandiver on 1/3/15.
//
//

#import "UICKeyChainItem.h"

@implementation UICKeyChainItem

- (instancetype)initWithData:(NSData *)data accessibility:(CFTypeRef)accessibility {
    self = [super init];
    if (self) {
        self.data = data;
        self.accessibility = accessibility;
    }
    return self;
}

@end