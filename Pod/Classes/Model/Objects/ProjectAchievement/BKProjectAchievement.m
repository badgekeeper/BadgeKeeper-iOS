//
//  BKProjectAchievement.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKProjectAchievement.h"


@implementation BKProjectAchievement


#pragma mark - BKObject

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _displayName = [json[@"DisplayName"] copy];
        _desc = [json[@"Description"] copy];
        _iconUnlocked = [json objectForKey:@"UnlockedIcon"];
        _iconLocked = [json objectForKey:@"LockedIcon"];
    }
    return self;
}

@end
