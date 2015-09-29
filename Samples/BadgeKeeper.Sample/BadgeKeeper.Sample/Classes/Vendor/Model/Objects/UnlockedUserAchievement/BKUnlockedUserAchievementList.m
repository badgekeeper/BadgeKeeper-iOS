//
//  BKUnlockedUserAchievementList.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKUnlockedUserAchievementList.h"
#import "BKUnlockedUserAchievement.h"

@implementation BKUnlockedUserAchievementList

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in json[@"Result"]) {
            id achievement = [[BKUnlockedUserAchievement alloc] initWithJSON:item];
            [list addObject:achievement];
        }
        _achievements = list;
    }
    return self;
}

@end
