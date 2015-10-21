//
//  BadgeKeeperAchievement.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperAchievement.h"

@implementation BadgeKeeperAchievement

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _displayName = [json[@"DisplayName"] copy];
        _desc = [json[@"Description"] copy];
        _iconUnlocked = [json[@"UnlockedIcon"] copy];
        _iconLocked = [json[@"LockedIcon"] copy];
    }
    return self;
}

@end
