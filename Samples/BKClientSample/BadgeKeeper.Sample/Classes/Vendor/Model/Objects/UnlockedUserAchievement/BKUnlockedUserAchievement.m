//
//  BKUnlockedUserAchievement.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKUnlockedUserAchievement.h"


@implementation BKUnlockedUserAchievement


#pragma mark - BKObject

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in json[@"Rewards"]) {
            [list addObject:[[BKKeyValuePair alloc] initWithJSON:item]];
        }
        _rewards = list;
        _achievement = [[BKUserAchievement alloc] initWithJSON:json];
    }
    return self;
}

@end
