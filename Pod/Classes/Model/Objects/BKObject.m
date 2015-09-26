//
//  BKObject.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKObject.h"


@implementation BKObject


#pragma mark - Root

- (instancetype)init {
    NSAssert(NO, @"Use 'initWithJSON:' instead.");
    return nil;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    return [super init];
}

@end
