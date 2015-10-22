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

#import <UIKit/UIImage.h>

#import "BadgeKeeper.h"
#import "BKApiService.h"
#import "BKApiResponse.h"
#import "BKApiResponseError.h"
#import "BKEntityStorage.h"
//#import "BadgeKeeperApiPacket.h"
//#import "BadgeKeeperApiPacketGetProjectAchievements.h"
//#import "BKNetPacketGetUserAchievements.h"
//#import "BKNetPacketSetUserChanges.h"
//#import "BKNetPacketIncrementUserChanges.h"
#import "BKApiRequestGetProjectAchievements.h"
#import "BKApiResponseGetProjectAchievements.h"

#import "BKApiRequestGetUserAchievements.h"
#import "BKApiResponseGetUserAchievements.h"

#import "BKProject.h"

// callbacks
//typedef void (^BadgeKeeperCallbackSendSuccess)(BKNetPacket *packet);

@interface BadgeKeeper () {
    NSMutableDictionary *postValues;
    NSMutableDictionary *incrementValues;
    BKEntityStorage *storage;
}

#pragma mark - Network

- (void)sendPacket:(BKApiRequest *)request
       withSuccess:(BKSuccessResponseCallback)success
        andFailure:(BKFailureResponseCallback)failure;

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
        storage = [BKEntityStorage new];
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

- (void)getProjectAchievementsWithSuccess:(BKAchievementsResponseCallback)success
                              withFailure:(BKFailureResponseCallback)failure {
    
    BKApiRequestGetProjectAchievements *request = [BKApiRequestGetProjectAchievements new];
    request.projectId = self.projectId;
    request.shouldLoadIcons = self.shouldLoadIcons;
    
    BKSuccessResponseCallback internalCallback = ^(id json) {
        BKApiResponseGetProjectAchievements *response = [[BKApiResponseGetProjectAchievements alloc] initWithJSON:json];
        success(response.project.achievements);
    };
    
    [self sendPacket:request withSuccess:internalCallback andFailure:failure];
}

- (void)getUserAchievementsWithSuccess:(BKUserAchievementsResponseCallback)success
                           withFailure:(BKFailureResponseCallback)failure {

    BKApiRequestGetUserAchievements *request = [BKApiRequestGetUserAchievements new];
    request.projectId = self.projectId;
    request.userId = self.userId;
    request.shouldLoadIcons = self.shouldLoadIcons;
    
    BKSuccessResponseCallback internalCallback = ^(id json) {
        BKApiResponseGetUserAchievements *response = [[BKApiResponseGetUserAchievements alloc] initWithJSON:json];
        success(response.achievements);
    };
    
    [self sendPacket:request withSuccess:internalCallback andFailure:failure];
}

/*
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
        packet.pairs = [pairs copy];
        
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
    if (packet.achievementsUnlocked) {
        result = [self getArrayOfItems:packet.achievementsUnlocked.achievements];
    }
    return result;
}

- (NSArray *)getArrayOfItems:(NSArray *)array {
    NSArray *result = [NSArray new];
    if (array && array.count > 0) {
        result = array;
    }
    return result;
}

- (void)saveRewardsForUnlockedAchievements:(BKUnlockedUserAchievementList *)list {
    if (list.achievements) {
        for (BKUnlockedUserAchievement *achievement in list.achievements) {
            if (achievement.rewards) {
                for (BKKeyValuePair *reward in achievement.rewards) {
                    [storage saveRewardValueForName:reward.key
                                          withValue:reward.value.doubleValue
                                            forUser:self.userId];
                }
            }
        }
    }
}

#pragma mark - Storage

- (BOOL)readRewardValuesForName:(NSString *)name withValues:(NSArray **)values {
    return [self readRewardValuesForName:name forUserId:self.userId withValues:values];
}

- (BOOL)readRewardValuesForName:(NSString *)name forUserId:(NSString *)userId withValues:(NSArray **)values {
    NSArray *result = [storage readRewardValuesForName:name forUser:userId];
    // Can not read result
    if (!result) {
        *values = nil;
        return NO;
    }
    
    *values = [result copy];
    return YES;
}*/

- (UIImage *)buildImageWithIconString:(NSString *)iconString {
    UIImage *result = nil;
    if (iconString && iconString != (id)[NSNull null] && iconString.length > 0) {
        NSData *data = [[NSData alloc]
                        initWithBase64EncodedString:iconString
                        options:NSDataBase64DecodingIgnoreUnknownCharacters];
        result = [UIImage imageWithData:data];
    }
    return result;
}

#pragma mark - Network

- (void)sendPacket:(BKApiRequest *)request
       withSuccess:(BKSuccessResponseCallback)success
        andFailure:(BKFailureResponseCallback)failure {
    
    [BKApiService sendRequest:request onSuccess:^(id json) {
        BKApiResponse *response = [[BKApiResponse alloc] initWithJSON:json];
        if (response.error) {
            failure(response.error.code, response.error.message);
        }
        else {
            success(json);
        }
    } onFailure:failure];
}

@end
