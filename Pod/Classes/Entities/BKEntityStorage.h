//
//  BKEntityStorage.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 29.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKEntityStorage : NSObject

- (void)saveRewardValueForName:(NSString *)name withValue:(double)value forUser:(NSString *)user;
- (NSArray *)readRewardValuesForName:(NSString *)name forUser:(NSString *)user;

@end
