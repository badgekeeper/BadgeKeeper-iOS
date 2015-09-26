//
//  BKNetPacketSetUserChanges.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
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
