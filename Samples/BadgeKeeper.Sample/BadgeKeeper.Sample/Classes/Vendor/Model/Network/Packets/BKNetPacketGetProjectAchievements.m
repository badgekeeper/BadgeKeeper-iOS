//
//  BKNetPacketGetProjectAchievements.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketGetProjectAchievements.h"


@implementation BKNetPacketGetProjectAchievements

@synthesize achievements = _achievements;


#pragma mark - Properties

- (NSString *)relativeURL {
    return [NSString stringWithFormat:@"api/gateway/%@/get?shouldLoadIcons=%@",
            self.projectId,
            (self.shouldLoadIcons) ? @"true" : @"false"];
}

- (NSString *)HTTPMethod {
    return @"GET";
}


#pragma mark - BKNetPacket

- (void)parseJSON:(id)json {
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *item in json[@"Result"]) {
        [result addObject:[[BKProjectAchievement alloc] initWithJSON:item]];
    }
    _achievements = result;
}

@end
