//
//  UICKeyChainItem.h
//  
//
//  Created by Bobby Vandiver on 1/3/15.
//
//

#import <Foundation/Foundation.h>

@interface UICKeyChainItem : NSObject

@property NSData *data;
@property CFTypeRef accessibility;

- (instancetype)initWithData:(NSData *)data accessibility:(CFTypeRef)accessibility;

@end