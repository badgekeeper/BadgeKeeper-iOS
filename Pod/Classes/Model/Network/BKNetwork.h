//
//  BKNetwork.h
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKNetPacket.h"

typedef void (^BKNetworkCallbackSuccess)(id json, NSURLResponse *response);
typedef void (^BKNetworkCallbackFailure)(NSURLResponse *response, NSError *error);


@interface BKNetwork : NSObject {
    
}

#pragma mark - Common

+ (void)sendPacket:(BKNetPacket *)packet
         onSuccess:(BKNetworkCallbackSuccess)success
         onFailure:(BKNetworkCallbackFailure)failure;

@end
