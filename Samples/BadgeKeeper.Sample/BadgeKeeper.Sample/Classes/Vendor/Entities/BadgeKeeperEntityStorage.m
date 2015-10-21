//
//  BadgeKeeperEntityStorage.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 29.09.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperEntityStorage.h"
#import "BadgeKeeperEntityReward.h"

@implementation BadgeKeeperEntityStorage

#pragma mark - General

- (void)saveRewardValueForName:(NSString *)name withValue:(double)value forUser:(NSString *)user {
    BadgeKeeperEntityReward *entity = [BadgeKeeperEntityReward new];
    entity.name = name;
    entity.user = user;
    entity.value = value;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:entity];
    [realm commitWriteTransaction];
}

- (NSArray *)readRewardValuesForName:(NSString *)name forUser:(NSString *)user {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND user == %@", name, user];
    RLMResults *results = [BadgeKeeperEntityReward objectsWithPredicate:predicate];
    
    NSMutableArray *array = [NSMutableArray new];
    for (RLMObject *object in results) {
        [array addObject:object];
    }
    return array;
}

@end
