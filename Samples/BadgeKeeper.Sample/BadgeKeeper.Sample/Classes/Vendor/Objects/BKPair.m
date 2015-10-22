//
//  BKPair.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKPair.h"

@implementation BKPair

#pragma mark - Root

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value {
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
