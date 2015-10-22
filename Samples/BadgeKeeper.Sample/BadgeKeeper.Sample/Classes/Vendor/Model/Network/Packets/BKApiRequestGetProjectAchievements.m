//
//  BKApiRequestGetProjectAchievements.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiRequestGetProjectAchievements.h"

@implementation BKApiRequestGetProjectAchievements

#pragma mark - Properties

- (NSString *)pathURL {
    return [NSString stringWithFormat:@"/api/gateway/%@/get", self.projectId];
}

- (NSString *)queryURL {
    NSString *request = (self.shouldLoadIcons) ? @"true" : @"false";
    return [NSString stringWithFormat:@"shouldLoadIcons=%@", request];
}

- (NSString *)HTTPMethod {
    return @"GET";
}

@end
