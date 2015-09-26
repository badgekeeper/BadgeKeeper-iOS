//
//  BKUnlockedUserAchievement.m
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
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
