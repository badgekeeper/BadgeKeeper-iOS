//
//  BKUnlockedUserAchievement.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"
#import "BKKeyValuePair.h"
#import "BKUserAchievement.h"


@interface BKUnlockedUserAchievement : BKObject {
    
}

@property (readonly, nonatomic) NSArray           *rewards;
@property (readonly, nonatomic) BKUserAchievement *achievement;

@end
