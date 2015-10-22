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

#import "BKPair.h"
#import "BKApiService.h"
#import "BKEntityStorage.h"

#import "BKApiRequestGetProjectAchievements.h"
#import "BKApiRequestGetUserAchievements.h"
#import "BKApiRequestSetUserChanges.h"
#import "BKApiRequestIncrementUserChanges.h"

#import "BKApiResponse.h"
#import "BKApiResponseError.h"
#import "BKApiResponseGetProjectAchievements.h"
#import "BKApiResponseGetUserAchievements.h"
#import "BKApiResponseSetUserChanges.h"
#import "BKApiResponseIncrementUserChanges.h"

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
        if (success) {
            success(response.project.achievements);
        }
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
        if (success) {
            success(response.achievements);
        }
    };
    
    [self sendPacket:request withSuccess:internalCallback andFailure:failure];
}

- (void)preparePostValue:(double)value forKey:(NSString *)key {
    [self prepareValue:value forKey:key intoDictionary:postValues];
}

- (void)prepareIncrementValue:(double)value forKey:(NSString *)key {
    [self prepareValue:value forKey:key intoDictionary:incrementValues];
}

- (void)prepareValue:(double)value forKey:(NSString *)key intoDictionary:(NSMutableDictionary *)dictionary {
    NSString *userId = self.userId;
    BKPair *pair = [[BKPair alloc] initWithKey:key value:@(value)];
    // Store pair
    if (![dictionary objectForKey:userId]) {
        [dictionary setObject:[NSMutableArray new] forKey:userId];
    }
    [dictionary[userId] addObject:pair];
}

- (void)postPreparedValuesWithSuccess:(BKAchievementsUnlockedCallback)success
                          withFailure:(BKFailureResponseCallback)failure {
    [self postPreparedValuesForUserId:self.userId
                          withSuccess:success
                          withFailure:failure];
}

- (void)postPreparedValuesForUserId:(NSString *)userId
                        withSuccess:(BKAchievementsUnlockedCallback)success
                        withFailure:(BKFailureResponseCallback)failure {
    // Validate values
    NSArray *pairs = [postValues objectForKey:userId];
    
    if (pairs && pairs.count > 0) {
        BKApiRequestSetUserChanges *request = [BKApiRequestSetUserChanges new];
        request.projectId = self.projectId;
        request.userId = userId;
        request.pairs = [pairs copy];
        
        // Clear values (TODO: write to DB, remove after successful response)
        [postValues removeObjectForKey:userId];
        
        BKAchievementsUnlockedCallback internallCalback = ^(id json) {
            BKApiResponseSetUserChanges *response = [[BKApiResponseSetUserChanges alloc] initWithJSON:json];
            
            // Save rewards if exist
            [self saveRewardsForUser:userId withUnlockedAchievements:response.achievements];
            // Return response
            if (success) {
                success(response.achievements);
            }
        };
        
        [self sendPacket:request withSuccess:internallCalback andFailure:failure];
    }
}

- (void)incrementPreparedValuesWithSuccess:(BKAchievementsUnlockedCallback)success
                               withFailure:(BKFailureResponseCallback)failure {
    [self incrementPreparedValuesForUserId:self.userId
                               withSuccess:success
                               withFailure:failure];
}

- (void)incrementPreparedValuesForUserId:(NSString *)userId
                             withSuccess:(BKAchievementsUnlockedCallback)success
                             withFailure:(BKFailureResponseCallback)failure {
    // Validate values
    NSArray *pairs = [incrementValues objectForKey:userId];
    
    if (pairs && pairs.count > 0) {
        BKApiRequestIncrementUserChanges *request = [BKApiRequestIncrementUserChanges new];
        request.projectId = self.projectId;
        request.userId = userId;
        request.pairs = [incrementValues objectForKey:userId];
        
        // Clear values (TODO: write to DB, remove after successful response)
        [incrementValues removeObjectForKey:userId];
        
        BKAchievementsUnlockedCallback internallCalback = ^(id json) {
            BKApiResponseIncrementUserChanges *response = [[BKApiResponseIncrementUserChanges alloc] initWithJSON:json];
            
            // Save rewards if exist
            [self saveRewardsForUser:userId withUnlockedAchievements:response.achievements];
            // Return response
            if (success) {
                success(response.achievements);
            }
        };
        
        [self sendPacket:request withSuccess:internallCalback andFailure:failure];
    }
}

/*!
 Save rewards to DB
 @param userId - specified user which hit achievement
 @param list - list of BKUnlockedAchievemnt elements
 */
- (void)saveRewardsForUser:(NSString *)userId withUnlockedAchievements:(NSArray *)list {
    if (list != nil && list.count > 0) {
        for (BKUnlockedAchievement *achievement in list) {
            if (achievement.rewards != nil && achievement.rewards.count > 0) {
                for (BKReward *reward in achievement.rewards) {
                    [storage saveRewardValueForName:reward.name
                                          withValue:reward.value
                                            forUser:userId];
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
}

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
            if (failure) {
                failure(response.error.code, response.error.message);
            }
        }
        else {
            success(json);
        }
    } onFailure:failure];
}

@end
