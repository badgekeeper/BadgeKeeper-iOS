//
//  BKNetPacketSetUserChanges.m
//  BKClientSample
//
//  Created by Георгий Малюков on 24.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKNetPacketSetUserChanges.h"


@implementation BKNetPacketSetUserChanges


#pragma mark - Properties

- (NSString *)relativeURL {
    return [NSString stringWithFormat:@"projects/%@/users/%@",
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
