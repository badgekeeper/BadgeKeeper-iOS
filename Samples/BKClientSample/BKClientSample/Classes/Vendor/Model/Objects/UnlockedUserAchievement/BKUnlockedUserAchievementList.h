//
//  BKUnlockedUserAchievementList.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"
#import "BKUnlockedUserAchievement.h"


@interface BKUnlockedUserAchievementList : BKObject {
    
}

@property (readonly, nonatomic) NSArray *achievements;

@end
