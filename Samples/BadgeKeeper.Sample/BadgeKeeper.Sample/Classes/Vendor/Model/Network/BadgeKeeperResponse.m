//
//  BadgeKeeperResponse.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperResponse.h"
#import "BadgeKeeperResponseError.h"

@implementation BadgeKeeperResponse

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        if (json[@"Error"] != nil && json[@"Error"] != [NSNull null]) {
            _error = [[BadgeKeeperResponseError alloc] initWithJSON:json[@"Error"]];
        }
        
#error TODO: how to detect class
        _result = [[BadgeKeeperObject alloc] initWithJSON:json[@"Result"]];
    }
    return self;
}

@end
