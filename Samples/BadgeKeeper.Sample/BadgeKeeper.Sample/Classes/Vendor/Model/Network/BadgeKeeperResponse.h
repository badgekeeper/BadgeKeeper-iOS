//
//  BadgeKeeperResponse.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperObject.h"

@class BadgeKeeperResponseError;

@interface BadgeKeeperResponse : BadgeKeeperObject {
    
}

@property (readonly, nonatomic) BadgeKeeperObject *result;
@property (readonly, nonatomic) BadgeKeeperResponseError *error;

@end
