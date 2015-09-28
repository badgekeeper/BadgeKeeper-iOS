//
//  Rewards.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 28.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Rewards : NSManagedObject

@property (nonnull, nonatomic, retain) NSString *name;
@property (nonnull, nonatomic, retain) NSNumber *value;

@end
