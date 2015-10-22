//
//  BKApiResponseGetProjectAchievements.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 22.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKApiResponseGetProjectAchievements.h"
#import "BKProject.h"

@implementation BKApiResponseGetProjectAchievements

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _project = nil;
        
        id result = json[@"Result"];
        if (result != nil && result != [NSNull null]) {
            _project = [[BKProject alloc] initWithJSON:result];
        }
    }
    return self;
}

@end
