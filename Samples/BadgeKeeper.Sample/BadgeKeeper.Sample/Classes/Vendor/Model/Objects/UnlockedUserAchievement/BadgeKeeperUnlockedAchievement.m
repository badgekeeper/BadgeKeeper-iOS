//
//  BadgeKeeperUnlockedAchievement.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperUnlockedAchievement.h"
#import "BadgeKeeperReward.h"

@implementation BadgeKeeperUnlockedAchievement

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in json[@"Rewards"]) {
            [list addObject:[[BadgeKeeperReward alloc] initWithJSON:item]];
        }
        _rewards = list;
    }
    return self;
}

@end
