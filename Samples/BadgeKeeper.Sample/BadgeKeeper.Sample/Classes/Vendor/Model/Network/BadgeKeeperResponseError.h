//
//  BadgeKeeperResponseError.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperObject.h"

@interface BadgeKeeperResponseError : BadgeKeeperObject {
    
}

@property (readonly, nonatomic) int       code;
@property (readonly, nonatomic) NSString *message;

@end
