//
//  BKNetPacketGetProjectAchievements.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
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
