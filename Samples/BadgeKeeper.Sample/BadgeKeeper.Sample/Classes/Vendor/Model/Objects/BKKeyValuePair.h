//
//  BKKeyValuePair.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"


@interface BKKeyValuePair : BKObject {
    
}

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSNumber *value;


#pragma mark - Root

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value;

@end
