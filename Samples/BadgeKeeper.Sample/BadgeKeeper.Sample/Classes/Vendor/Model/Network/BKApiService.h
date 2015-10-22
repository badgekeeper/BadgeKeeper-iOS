//
//  BKApiService.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BKApiRequest.h"

/// Callbacks
typedef void (^BKAchievementsResponseCallback)(NSArray *achievements);
typedef void (^BKUserAchievementsResponseCallback)(NSArray *achievements);
//typedef void (^BadgeKeeperAchievementsUnlockedCallback)(NSArray *achievements);

typedef void (^BKFailureResponseCallback)(int code, NSString *message);
typedef void (^BKSuccessResponseCallback)(id json);

@interface BKApiService : NSObject {
    
}

#pragma mark - Common

+ (void)sendRequest:(BKApiRequest *)request
          onSuccess:(BKSuccessResponseCallback)success
          onFailure:(BKFailureResponseCallback)failure;

@end
