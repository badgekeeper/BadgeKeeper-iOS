//
//  BadgeKeeperObject.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperObject.h"

@implementation BadgeKeeperObject

#pragma mark - Root

- (instancetype)init {
    NSAssert(NO, @"Use 'initWithJSON:' instead.");
    return nil;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    return [super init];
}

@end
