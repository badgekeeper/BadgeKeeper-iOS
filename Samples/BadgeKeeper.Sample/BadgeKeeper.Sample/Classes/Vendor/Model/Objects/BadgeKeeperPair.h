//
//  BadgeKeeperPair.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeKeeperPair : NSObject {
    
}

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSNumber *value;

- (instancetype)initWithKey:(NSString *)key value:(NSNumber *)value;

@end
