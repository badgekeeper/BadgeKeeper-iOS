//
//  BKNetwork.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
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
