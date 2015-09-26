//
//  BKKeyValuePair.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
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

@end
