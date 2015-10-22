//
//  BKApiResponseSetUserChanges.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 22.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKApiResponseSetUserChanges.h"
#import "BKUnlockedAchievement.h"

@implementation BKApiResponseSetUserChanges

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        id result = json[@"Result"];
        if (result != nil && result != [NSNull null]) {
            for (NSDictionary *item in result) {
                [list addObject:[[BKUnlockedAchievement alloc] initWithJSON:item]];
            }
        }
        _achievements = list;
    }
    return self;
}

@end
