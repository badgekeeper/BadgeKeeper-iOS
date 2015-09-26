//
//  BKNetPacketGetProjectAchievements.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacket.h"
#import "BKProjectAchievement.h"


@interface BKNetPacketGetProjectAchievements : BKNetPacket {
    NSMutableArray *_achievements;
}
// in
@property (copy, nonatomic)   NSString *projectId;
@property (assign, nonatomic) BOOL     shouldLoadIcons;
// out
@property (readonly, nonatomic) NSArray *achievements;

@end
