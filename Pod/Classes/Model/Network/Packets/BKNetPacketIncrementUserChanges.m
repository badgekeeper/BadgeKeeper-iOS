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

- (NSString *)relativeURL {
    return [NSString stringWithFormat:@"api/gateway/%@/users/increment/%@",
            self.projectId,
            self.userId];
}


#pragma mark - BKNetPacket

- (NSString *)body {
    NSMutableString *body = [[NSMutableString alloc] initWithString:@"[ "];
    
    for (BKKeyValuePair *pair in self.pairs) {
        [body appendString:pair.description];
    }
    [body appendString:@" ]"];
    
    return body;
}

- (void)parseJSON:(id)json {
    _achievementsUnlocked = [[BKUnlockedUserAchievementList alloc] initWithJSON:json];
}

@end
