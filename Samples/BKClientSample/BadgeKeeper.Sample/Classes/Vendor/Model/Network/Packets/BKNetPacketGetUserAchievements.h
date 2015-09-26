//
//  BKNetPacketGetUserAchievements.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketGetProjectAchievements.h"
#import "BKUserAchievement.h"


@interface BKNetPacketGetUserAchievements : BKNetPacketGetProjectAchievements {
    
}
// in
@property (copy, nonatomic) NSString *userId;

@end
