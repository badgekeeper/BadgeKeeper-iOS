//
//  BKUnlockedUserAchievement.h
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKObject.h"
#import "BKKeyValuePair.h"
#import "BKUserAchievement.h"


@interface BKUnlockedUserAchievement : BKObject {
    
}

@property (readonly, nonatomic) NSArray           *rewards;
@property (readonly, nonatomic) BKUserAchievement *achievement;

@end
