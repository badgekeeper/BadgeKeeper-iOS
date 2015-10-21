//
//  BadgeKeeperReward.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperReward.h"

@implementation BadgeKeeperReward

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _name = [json[@"Name"] copy];
        _value = [json[@"Value"] doubleValue];
    }
    return self;
}

@end
