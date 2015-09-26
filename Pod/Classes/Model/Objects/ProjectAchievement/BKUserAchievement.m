//
//  BKUserAchievement.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
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
