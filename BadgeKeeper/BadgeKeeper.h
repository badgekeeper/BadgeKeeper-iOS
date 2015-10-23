// Copyright 2015 Badge Keeper
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>

#import "BKApiService.h"

#import "BKProject.h"
#import "BKAchievement.h"
#import "BKUserAchievement.h"
#import "BKUnlockedAchievement.h"
#import "BKReward.h"

@class UIImage;

#pragma mark - Callbacks

// Returns array of BKAchievement elements
typedef void (^BKAchievementsResponseCallback)(NSArray *achievements);
// Returns array of BKUserAchievement elements
typedef void (^BKUserAchievementsResponseCallback)(NSArray *achievements);
// Returns array of BKUnlockedAchievement elements
typedef void (^BKAchievementsUnlockedCallback)(NSArray *achievements);

/// Manages BadgeKeeper service environment.
@interface BadgeKeeper : NSObject {

}

/// Active BadgeKeeper project ID.
@property (copy, nonatomic) NSString *projectId;

/// Active BadgeKeeper user ID.
@property (copy, nonatomic) NSString *userId;

/// Indicates whether the BadgeKeeper should load icons from the BadgeKeeper service.
@property (nonatomic) BOOL shouldLoadIcons;


#pragma mark - Root

+ (instancetype)instance;


#pragma mark - Service

/*!
 Get all project achievements list.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)getProjectAchievementsWithSuccess:(BKAchievementsResponseCallback)success
                              withFailure:(BKFailureResponseCallback)failure;

/*!
 Get all achievements by the specified user Id.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)getUserAchievementsWithSuccess:(BKUserAchievementsResponseCallback)success
                           withFailure:(BKFailureResponseCallback)failure;

/*!
 Sets a new value for specified key.
 @param value - New value to set. Old value will be overwritten.
 @param key - Target key to validate achievements.
 */
- (void)preparePostValue:(double)value forKey:(NSString *)key;

/*!
 Sets a new value for specified key.
 @param value - Increment old value.
 @param key - Target key to validate achievements.
 */
- (void)prepareIncrementValue:(double)value forKey:(NSString *)key;

/*!
 Sends all prepared values to server to overwrite them and validate achievements completion.
 @discussion Before sending values must be prepared via <tt>preparePostValue:forKey:</tt> method calls.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)postPreparedValuesWithSuccess:(BKAchievementsUnlockedCallback)success
                          withFailure:(BKFailureResponseCallback)failure;

/*!
 Overloaded postPreparedValues for specific user.
 @discussion Before sending values must be prepared via <tt>preparePostValue:forKey</tt> method calls.
 @param userId - User ID which prepared values should be sent. If set to <tt>nil</tt> then current active user ID will be used.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)postPreparedValuesForUserId:(NSString *)userId
                        withSuccess:(BKAchievementsUnlockedCallback)success
                        withFailure:(BKFailureResponseCallback)failure;

/*!
 Sends all prepared values to server to increment them and validate achievements completion.
 @discussion Before sending values must be prepared via <tt>prepareIncrementValue:forKey:</tt> method calls. After successful sending all prepared values will be removed from memory.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)incrementPreparedValuesWithSuccess:(BKAchievementsUnlockedCallback)success
                               withFailure:(BKFailureResponseCallback)failure;

/*!
 Overloaded incrementPreparedValues for specific user.
 @discussion Before sending values must be prepared via <tt>prepareIncrementValue:forKey:</tt> method calls. After successful sending all prepared values will be removed from memory.
 @param userId - User ID which prepared values should be sent. If set to <tt>nil</tt> then current active user ID will be used.
 @param success - Successful callback function
 @param failure - Failure callback function
 */
- (void)incrementPreparedValuesForUserId:(NSString *)userId
                             withSuccess:(BKAchievementsUnlockedCallback)success
                             withFailure:(BKFailureResponseCallback)failure;

/*!
 Try to read reward value from storage.
 @param name - Which value to read.
 @param out values - Output array values for <tt>name</tt> parameter.
 @return - YES (if parameter successfully taken), NO (otherwise).
 */
- (BOOL)readRewardValuesForName:(NSString *)name withValues:(NSArray **)values;

/*!
 Overloaded readRewardValuesForName for specific user.
 @param name - Which value to read.
 @param userId - Which user rewards should read.
 @param out values - Output array values for <tt>name</tt> parameter.
 @return - YES (if parameter successfully taken), NO (otherwise).
 */
- (BOOL)readRewardValuesForName:(NSString *)name forUserId:(NSString *)userId withValues:(NSArray **)values;

#pragma mark - Extra Functions

/*!
 Build image with raw icon data.
 @param iconString - raw icon data from BadgeKeeper service for UnlockedIcon or LockedIcon.
 @return - image (if data exist), nil (otherwise).
 */
- (UIImage *)buildImageWithIconString:(NSString *)iconString;

@end
