//
//  BKKeyValuePair.h
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKObject.h"


@interface BKKeyValuePair : BKObject {
    
}

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSNumber *value;


#pragma mark - Root

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value;

@end
