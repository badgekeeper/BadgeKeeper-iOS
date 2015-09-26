//
//  BKNetPacketGetUserAchievements.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketGetProjectAchievements.h"
#import "BKUserAchievement.h"


@interface BKNetPacketGetUserAchievements : BKNetPacketGetProjectAchievements {
    
}
// in
@property (copy, nonatomic) NSString *userId;

@end
