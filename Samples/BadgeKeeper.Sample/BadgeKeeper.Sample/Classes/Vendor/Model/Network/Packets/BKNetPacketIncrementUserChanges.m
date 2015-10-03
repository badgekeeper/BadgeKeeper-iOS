//
//  BKNetPacketIncrementUserChanges.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketIncrementUserChanges.h"


@implementation BKNetPacketIncrementUserChanges


#pragma mark - Properties

- (NSString *)pathURL {
    return [NSString stringWithFormat:@"/api/gateway/%@/users/increment/%@", self.projectId, self.userId];
}

- (NSString *)queryURL {
    return @"";
}

@end
