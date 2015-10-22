//
//  BKProject.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKProject.h"
#import "BKAchievement.h"

@implementation BKProject

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _title = [json[@"Title"] copy];
        _desc = [json[@"Description"] copy];
        _icon = [json[@"Icon"] copy];
        
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in json[@"Achievements"]) {
            [list addObject:[[BKAchievement alloc] initWithJSON:item]];
        }
        _achievements = list;
    }
    return self;
}

@end
