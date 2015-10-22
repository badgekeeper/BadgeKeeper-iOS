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

#import <Foundation/Foundation.h>

#import "BKApiService.h"
//#import "BadgeKeeperUserAchievement.h"
//#import "BadgeKeeperUnlockedAchievement.h"
//#import "BadgeKeeperEntityAchievement.h"
//#import "BadgeKeeperEntityReward.h"

@class UIImage;

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

/// Get all project achievements list.
- (void)getProjectAchievementsWithSuccess:(BKAchievementsResponseCallback)success
                              withFailure:(BKFailureResponseCallback)failure;

/// Get all achievements by the specified user Id.
- (void)getUserAchievementsWithSuccess:(BKUserAchievementsResponseCallback)success
                           withFailure:(BKFailureResponseCallback)failure;

/*!
 Sets a new value for specified key.
 @param value - New value to set. Old value will be overwritten.
 @param key - Target key to validate achievements.
 */
//- (void)preparePostValue:(double)value forKey:(NSString *)key;

/*!
 Sets a new value for specified key.
 @param value - Increment old value.
 @param key - Target key to validate achievements.
 */
//- (void)prepareIncrementValue:(double)value forKey:(NSString *)key;

/*!
 Sends all prepared values to server to overwrite them and validate achievements completion.
 @discussion Before sending values must be prepared via <tt>preparePostValue:forKey:</tt> method calls.
 */
//- (void)postPreparedValues;

/*!
 Overloaded postPreparedValues for specific user.
 @discussion Before sending values must be prepared via <tt>preparePostValue:forKey</tt> method calls.
 @param userId - User ID which prepared values should be sent. If set to <tt>nil</tt> then current active user ID will be used.
 */
//- (void)postPreparedValuesForUserId:(NSString *)userId;

/*!
 Sends all prepared values to server to increment them and validate achievements completion.
 @discussion Before sending values must be prepared via <tt>prepareIncrementValue:forKey:</tt> method calls. After successful sending all prepared values will be removed from memory.
 */
//- (void)incrementPreparedValues;

/*!
 Overloaded incrementPreparedValues for specific user.
 @discussion Before sending values must be prepared via <tt>prepareIncrementValue:forKey:</tt> method calls. After successful sending all prepared values will be removed from memory.
 @param userId - User ID which prepared values should be sent. If set to <tt>nil</tt> then current active user ID will be used.
 */
//- (void)incrementPreparedValuesForUserId:(NSString *)userId;

/*!
 Try to read reward value from storage.
 @param name - Which value to read.
 @param out values - Output array values for <tt>name</tt> parameter.
 @return - YES (if parameter successfully taken), NO (otherwise).
 */
//- (BOOL)readRewardValuesForName:(NSString *)name withValues:(NSArray **)values;

/*!
 Overloaded readRewardValuesForName for specific user.
 @param name - Which value to read.
 @param userId - Which user rewards should read.
 @param out values - Output array values for <tt>name</tt> parameter.
 @return - YES (if parameter successfully taken), NO (otherwise).
 */
//- (BOOL)readRewardValuesForName:(NSString *)name forUserId:(NSString *)userId withValues:(NSArray **)values;

#pragma mark - Extra Functions

/*!
 Build image with raw icon data.
 @param iconString - raw icon data from BadgeKeeper service for UnlockedIcon or LockedIcon.
 @return - image (if data exist), nil (otherwise).
 */
- (UIImage *)buildImageWithIconString:(NSString *)iconString;

@end
