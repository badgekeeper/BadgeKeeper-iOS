//
//  BKUserAchievement.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKUserAchievement.h"


@implementation BKUserAchievement


#pragma mark - BKObject

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _isUnlocked = [json[@"IsUnlocked"] boolValue];
    }
    return self;
}

@end
