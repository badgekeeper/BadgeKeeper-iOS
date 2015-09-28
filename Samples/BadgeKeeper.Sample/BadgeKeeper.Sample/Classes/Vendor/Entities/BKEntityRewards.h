//
//  BKEntityRewards.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 28.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BKEntityRewards : NSManagedObject

@property (nonnull, nonatomic, retain) NSString *name;
@property (nonnull, nonatomic, retain) NSNumber *value;

@end
