//
//  BKApiResponseError.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKApiResponseError.h"

@implementation BKApiResponseError

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _code = [json[@"Code"] intValue];
        _message = [json[@"Message"] copy];
    }
    return self;
}

@end
