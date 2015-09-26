//
//  BKUnlockedUserAchievement.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"
#import "BKKeyValuePair.h"
#import "BKUserAchievement.h"


@interface BKUnlockedUserAchievement : BKObject {
    
}

@property (readonly, nonatomic) NSArray           *rewards;
@property (readonly, nonatomic) BKUserAchievement *achievement;

@end
