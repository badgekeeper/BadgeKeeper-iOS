//
//  BKApiRequestGetUserAchievements.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiRequestGetUserAchievements.h"

@implementation BKApiRequestGetUserAchievements

#pragma mark - Properties

- (NSString *)pathURL {
    return [NSString stringWithFormat:@"/api/gateway/%@/users/get/%@",
            self.projectId, self.userId];
}

- (NSString *)queryURL {
    NSString *request = (self.shouldLoadIcons) ? @"true" : @"false";
    return [NSString stringWithFormat:@"shouldLoadIcons=%@", request];
}

- (NSString *)HTTPMethod {
    return @"GET";
}

@end
