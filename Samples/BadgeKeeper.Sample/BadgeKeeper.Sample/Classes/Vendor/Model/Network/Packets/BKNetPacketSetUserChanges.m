//
//  BKNetPacketSetUserChanges.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketSetUserChanges.h"


@implementation BKNetPacketSetUserChanges


#pragma mark - Properties

- (NSString *)pathURL {
    return [NSString stringWithFormat:@"/api/gateway/%@/users/post/%@", self.projectId, self.userId];
}

- (NSString *)queryURL {
    return @"";
}

#pragma mark - BKNetPacket

- (NSString *)body {
    NSMutableString *body = [[NSMutableString alloc] initWithString:@"["];
    
    for (BKKeyValuePair *pair in self.pairs) {
        [body appendString:pair.description];
        if ([self.pairs lastObject] != pair) {
            [body appendString:@","];
        }
    }
    [body appendString:@"]"];
    return body;
}

- (void)parseJSON:(id)json {
    _achievementsUnlocked = [[BKUnlockedUserAchievementList alloc] initWithJSON:json];
}

@end
