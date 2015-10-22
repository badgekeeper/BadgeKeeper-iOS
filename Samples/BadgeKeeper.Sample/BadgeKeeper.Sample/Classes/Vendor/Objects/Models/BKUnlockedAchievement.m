//
//  BKUnlockedAchievement.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKUnlockedAchievement.h"
#import "BKReward.h"

@implementation BKUnlockedAchievement

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in json[@"Rewards"]) {
            [list addObject:[[BKReward alloc] initWithJSON:item]];
        }
        _rewards = list;
    }
    return self;
}

@end
