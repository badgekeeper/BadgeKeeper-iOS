//
//  BKKeyValuePair.m
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKKeyValuePair.h"


@implementation BKKeyValuePair


#pragma mark - BKObject

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        self.key = json[@"Key"];
        self.value = json[@"Value"];
    }
    return self;
}


#pragma mark - Root

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value {
    return [self initWithJSON:@{@"Key": key, @"Value": value}];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"{ \"Key\": %@, \"Value\": %f }",
            self.key,
            self.value.doubleValue];
}

@end
