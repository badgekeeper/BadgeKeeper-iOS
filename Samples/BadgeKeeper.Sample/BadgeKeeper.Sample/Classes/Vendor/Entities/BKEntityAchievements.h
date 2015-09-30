//
//  BKEntityAchievements.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 28.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface BKEntityAchievements : RLMObject

@property NSString *name;
@property NSString *user;
@property NSString *desc;
@property NSData *icon;

@end
