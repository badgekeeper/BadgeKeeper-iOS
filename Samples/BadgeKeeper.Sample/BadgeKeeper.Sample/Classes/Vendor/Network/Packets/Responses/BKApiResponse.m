//
//  BKApiResponse.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKApiResponse.h"
#import "BKApiResponseError.h"

@implementation BKApiResponse

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _error = nil;
        if (json[@"Error"] != nil && json[@"Error"] != [NSNull null]) {
            _error = [[BKApiResponseError alloc] initWithJSON:json[@"Error"]];
        }
    }
    return self;
}

@end
