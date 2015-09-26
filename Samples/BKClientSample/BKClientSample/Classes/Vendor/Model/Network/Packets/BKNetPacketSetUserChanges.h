//
//  BKNetPacketSetUserChanges.h
//  BKClientSample
//
//  Created by Георгий Малюков on 24.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacket.h"
#import "BKKeyValuePair.h"
#import "BKUnlockedUserAchievementList.h"


@interface BKNetPacketSetUserChanges : BKNetPacket {
    
}
// in
@property (copy, nonatomic)   NSString *projectId;
@property (copy, nonatomic)   NSString *userId;
@property (strong, nonatomic) NSArray  *pairs;
// out
@property (readonly, nonatomic) BKUnlockedUserAchievementList *achievementsUnlocked;

@end
