//
//  BKKeyValuePair.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKKeyValuePair.h"


@implementation BKKeyValuePair


#pragma mark - BKObject

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        self.key = [json valueForKey:@"Name"];
        double const value = [[json valueForKey:@"Value"] doubleValue];
        self.value = [NSNumber numberWithDouble:value];
    }
    return self;
}


#pragma mark - Root

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value {
    return [self initWithJSON:@{@"Name": key, @"Value": value}];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"{\"Key\":\"%@\",\"Value\":%f}", self.key, self.value.doubleValue];
}

@end
