//
//  BKApiRequestSetUserChanges.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiRequestSetUserChanges.h"
#import "BKPair.h"

@implementation BKApiRequestSetUserChanges

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
    for (BKPair *pair in self.pairs) {
        NSString *node = [NSString stringWithFormat:@"{\"Key\":\"%@\", \"Value\":%@}",
                          pair.key, pair.value];
        [body appendString:node];
        if ([self.pairs lastObject] != pair) {
            [body appendString:@","];
        }
    }
    [body appendString:@"]"];
    return body;
}

@end
