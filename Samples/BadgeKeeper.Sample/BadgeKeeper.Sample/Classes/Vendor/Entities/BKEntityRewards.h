//
//  BKEntityRewards.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 28.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface BKEntityRewards : RLMObject

@property NSString *name;
@property NSString *user;
@property double value;

@end
