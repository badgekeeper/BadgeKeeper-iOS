//
//  BKNetPacketGetProjectAchievements.m
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketGetProjectAchievements.h"


@implementation BKNetPacketGetProjectAchievements

@synthesize achievements = _achievements;


#pragma mark - Properties

- (NSString *)relativeURL {
    return [NSString stringWithFormat:@"projects/%@/%@",
            self.projectId,
            (self.shouldLoadIcons) ? @"true" : @"false"];
}

- (NSString *)HTTPMethod {
    return @"GET";
}


#pragma mark - BKNetPacket

- (void)parseJSON:(id)json {
    NSMutableArray *result = [NSMutableArray new];
    
    NSArray *list = json;
    for (NSDictionary *item in list) {
        [result addObject:[[BKProjectAchievement alloc] initWithJSON:item]];
    }
    _achievements = result;
}

@end
