//
//  BKEntityStorage.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 29.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKEntityStorage : NSObject

- (BOOL)saveRewardValueForName:(NSString *)name withValue:(double)value;
- (NSArray *)readRewardValuesForName:(NSString *)name;

@end
