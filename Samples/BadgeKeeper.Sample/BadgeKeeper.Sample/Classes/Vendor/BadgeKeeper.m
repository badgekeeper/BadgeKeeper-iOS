/*
 
 BadgeKeeper
 
 The MIT License (MIT)
 
 Copyright (c) 2015 Alexander Pukhov, BadgeKeeper
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "BadgeKeeper.h"
#import "BKNetwork.h"
#import "BKEntityStorage.h"
#import "BKNetPacketGetProjectAchievements.h"
#import "BKNetPacketGetUserAchievements.h"
#import "BKNetPacketSetUserChanges.h"
#import "BKNetPacketIncrementUserChanges.h"

// notifications
NSString *const kBKNotificationDidReceiveProjectAchievements = @"kBKNotificationDidReceiveProjectAchievements";
NSString *const kBKNotificationFailedReceiveProjectAchievements = @"kBKNotificationFailedReceiveProjectAchievements";
NSString *const kBKNotificationDidReceiveUserAchievements = @"kBKNotificationDidReceiveUserAchievements";
NSString *const kBKNotificationFailedReceiveUserAchievements = @"kBKNotificationFailedReceiveUserAchievements";
NSString *const kBKNotificationDidPostPreparedValues = @"kBKNotificationDidPostPreparedValues";
NSString *const kBKNotificationFailedPostPreparedValues = @"kBKNotificationFailedPostPreparedValues";
NSString *const kBKNotificationDidIncrementPreparedValues = @"kBKNotificationDidIncrementPreparedValues";
NSString *const kBKNotificationFailedIncrementPreparedValues = @"kBKNotificationFailedIncrementPreparedValues";

// notifications keys
NSString *const kBKNotificationKeyResponseObject = @"ResponseObject";
NSString *const kBKNotificationKeyErrorResponse = @"ErrorResponse";
NSString *const kBKNotificationKeyErrorObject = @"ErrorObject";

// callbacks
typedef void (^BadgeKeeperCallbackSendSuccess)(BKNetPacket *packet);


@interface BadgeKeeper () {
    NSMutableDictionary *postValues;
    NSMutableDictionary *incrementValues;
    BKEntityStorage *storage;
}

#pragma mark - Network

- (void)sendPacket:(BKNetPacket *)packet
         onSuccess:(BadgeKeeperCallbackSendSuccess)success
         onFailure:(BKNetworkCallbackFailure)failure;


#pragma mark - Notifications

- (void)notify:(NSString *)notificationName responseObject:(id)object;
- (void)notifyError:(NSString *)notificationName
           response:(NSURLResponse *)response
              error:(NSError *)error;

@end


@implementation BadgeKeeper

#pragma mark - Root

- (instancetype)init {
    NSAssert(0, @"Use 'instance' instead.");
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        postValues = [NSMutableDictionary new];
        incrementValues = [NSMutableDictionary new];
        storage = [[BKEntityStorage alloc] init];
    }
    return self;
}

+ (instancetype)instance {
    static BadgeKeeper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initPrivate];
    });
    return instance;
}


#pragma mark - Service

- (void)requestProjectAchievements {
    BKNetPacketGetProjectAchievements *packet = [BKNetPacketGetProjectAchievements new];
    
    packet.projectId = self.projectId;
    packet.shouldLoadIcons = self.shouldLoadIcons;
    
    [self sendPacket:packet
           onSuccess:^(BKNetPacket *packet) {
               [self notify:kBKNotificationDidReceiveProjectAchievements responseObject:packet];
           }
           onFailure:^(NSURLResponse *response, NSError *error) {
               [self notifyError:kBKNotificationFailedReceiveProjectAchievements
                        response:response
                           error:error];
           }];
}

- (void)requestUserAchievements {
    BKNetPacketGetUserAchievements *packet = [BKNetPacketGetUserAchievements new];
    
    packet.projectId = self.projectId;
    packet.userId = self.userId;
    packet.shouldLoadIcons = self.shouldLoadIcons;
    
    [self sendPacket:packet
           onSuccess:^(BKNetPacket *packet) {
               [self notify:kBKNotificationDidReceiveUserAchievements responseObject:packet];
           }
           onFailure:^(NSURLResponse *response, NSError *error) {
               [self notifyError:kBKNotificationFailedReceiveUserAchievements
                        response:response
                           error:error];
           }];
}

- (void)preparePostValue:(double)value forKey:(NSString *)key {
    [self prepareValue:value forKey:key intoDictionary:postValues];
}

- (void)prepareIncrementValue:(double)value forKey:(NSString *)key {
    [self prepareValue:value forKey:key intoDictionary:incrementValues];
}

- (void)prepareValue:(double)value forKey:(NSString *)key intoDictionary:(NSMutableDictionary *)dictionary {
    NSString *userId = self.userId;
    BKKeyValuePair *pair = [[BKKeyValuePair alloc] initWithKey:key value:@(value)];
    // Store pair
    if (![dictionary objectForKey:userId]) {
        [dictionary setObject:[NSMutableArray new] forKey:userId];
    }
    [dictionary[userId] addObject:pair];
}

- (void)postPreparedValues {
    [self postPreparedValuesForUserId:self.userId];
}

- (void)postPreparedValuesForUserId:(NSString *)userId {
    // Validate values
    NSArray *pairs = [postValues objectForKey:userId];
    
    if (pairs && pairs.count > 0) {
        BKNetPacketSetUserChanges *packet = [BKNetPacketSetUserChanges new];
        packet.projectId = self.projectId;
        packet.userId = userId;
        packet.pairs = [pairs mutableCopy];
        
        // Clear values
        [postValues removeObjectForKey:userId];
        
        [self sendPacket:packet
               onSuccess:^(BKNetPacket *packet) {
                   // remove prepared values
                   BKNetPacketSetUserChanges *data = (BKNetPacketSetUserChanges *)packet;
                   NSArray *unlocked = [self getUnlockedAchievements:data];
                   [self saveRewardsForUnlockedAchievements:data.achievementsUnlocked];
                   
                   [self notify:kBKNotificationDidIncrementPreparedValues responseObject:unlocked];
               }
               onFailure:^(NSURLResponse *response, NSError *error) {
                   [self notifyError:kBKNotificationFailedIncrementPreparedValues response:response error:error];
               }];
    }
}

- (void)incrementPreparedValues {
    [self incrementPreparedValuesForUserId:self.userId];
}

- (void)incrementPreparedValuesForUserId:(NSString *)userId {
    // Validate values
    NSArray *pairs = [incrementValues objectForKey:userId];
    
    if (pairs && pairs.count > 0) {
        BKNetPacketIncrementUserChanges *packet = [BKNetPacketIncrementUserChanges new];
        packet.projectId = self.projectId;
        packet.userId = userId;
        packet.pairs = [incrementValues objectForKey:userId];

        // Clear values
        [incrementValues removeObjectForKey:userId];
        
        [self sendPacket:packet
               onSuccess:^(BKNetPacket *packet) {
                   BKNetPacketIncrementUserChanges *data = (BKNetPacketIncrementUserChanges *)packet;
                   NSArray *unlocked = [self getUnlockedAchievements:data];
                   [self saveRewardsForUnlockedAchievements:data.achievementsUnlocked];
                   
                   [self notify:kBKNotificationDidPostPreparedValues responseObject:unlocked];
               }
               onFailure:^(NSURLResponse *response, NSError *error) {
                   [self notifyError:kBKNotificationFailedPostPreparedValues response:response error:error];
               }];
    }
}

- (NSArray *)getUnlockedAchievements:(BKNetPacketSetUserChanges *)packet {
    NSArray *result = [NSArray new];
    if (packet.achievementsUnlocked && packet.achievementsUnlocked.achievements) {
        result = packet.achievementsUnlocked.achievements;
    }
    return result;
}

- (void)saveRewardsForUnlockedAchievements:(BKUnlockedUserAchievementList *)list {
    if (list.achievements) {
        for (BKUnlockedUserAchievement *achievement in list.achievements) {
            if (achievement.rewards) {
                for (BKKeyValuePair *reward in achievement.rewards) {
                    [storage saveRewardValueForName:reward.key withValue:reward.value.doubleValue];
                }
            }
        }
    }
}

#pragma mark - Storage

- (BOOL)readRewardValuesForName:(NSString *)name withValues:(NSArray **)values {
    NSArray *result = [storage readRewardValuesForName:name];
    // Can not read result
    if (!result) {
        *values = nil;
        return NO;
    }
    
    *values = [result mutableCopy];
    return YES;
}

#pragma mark - Network

- (void)sendPacket:(BKNetPacket *)packet
         onSuccess:(BadgeKeeperCallbackSendSuccess)success
         onFailure:(BKNetworkCallbackFailure)failure {
    [BKNetwork sendPacket:packet
                onSuccess:^(id json, NSURLResponse *response) {
                    if (success) {
                        [packet parseJSON:json];
                        success(packet);
                    }
                }
                onFailure:^(NSURLResponse *response, NSError *error) {
                    if (failure) {
                        failure(response, error);
                    }
                }];
}


#pragma mark - Notifications

- (void)notify:(NSString *)notificationName responseObject:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self
                                                      userInfo:@{kBKNotificationKeyResponseObject:object}];
}

- (void)notifyError:(NSString *)notificationName response:(NSURLResponse *)response error:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self
                                                      userInfo:@{kBKNotificationKeyErrorResponse:response,
                                                                 kBKNotificationKeyErrorObject:error}];
}


@end
