//
//  BKPacket.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKNetPacket.h"


@implementation BKNetPacket


#pragma mark - Root

- (instancetype)init {
    self = [super init];
    if (self) {
        _HTTPMethod = @"POST"; // default is POST
    }
    return self;
}


#pragma mark - Parsing

- (void)parseJSON:(id)json {
    // pure virtual
}

@end
