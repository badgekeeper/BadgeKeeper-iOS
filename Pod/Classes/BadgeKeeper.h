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
#import "BKUserAchievement.h"
#import "BKUnlockedUserAchievementList.h"

// notifications
FOUNDATION_EXPORT NSString *const kBKNotificationDidReceiveProjectAchievements;
FOUNDATION_EXPORT NSString *const kBKNotificationFailedReceiveProjectAchievements;
FOUNDATION_EXPORT NSString *const kBKNotificationDidReceiveUserAchievements;
FOUNDATION_EXPORT NSString *const kBKNotificationFailedReceiveUserAchievements;
FOUNDATION_EXPORT NSString *const kBKNotificationDidSendPreparedValues;
FOUNDATION_EXPORT NSString *const kBKNotificationFailedSendPreparedValues;

// notifications keys
FOUNDATION_EXPORT NSString *const kBKNotificationKeyResponseObject;
FOUNDATION_EXPORT NSString *const kBKNotificationKeyErrorResponse;
FOUNDATION_EXPORT NSString *const kBKNotificationKeyErrorObject;


/// Manages BadgeKeeper service environment.
@interface BadgeKeeper : NSObject {
    
}
/// Active BadgeKeeper project ID.
@property (copy, nonatomic) NSString *projectId;

/// Active BadgeKeeper user ID.
@property (copy, nonatomic) NSString *userId;

/// Indicates whether the BadgeKeeper should load icons from the BadgeKeeper service.
@property (readonly, nonatomic) BOOL shouldLoadIcons;


#pragma mark - Root

+ (instancetype)instance;


#pragma mark - Service

/// Requests all project achievements list.
- (void)requestProjectAchievements;

/// Requests all achievements that are unlocked by the specified user ID.
- (void)requestUserAchievements;

/*!
 Sets a new value for specified achievement ID.
 @param value New value to set. Old value will be overwritten.
 @param achievementId Target achievement ID.
 */
- (void)prepareValue:(double)value forAchievementId:(NSString *)achievementId;

/*!
 Sends all prepared values to server.
 @discussion Before sending values must be prepared via <tt>prepareValue:forAchievementId:</tt> method calls. After successful sending all prepared values will be removed from memory.
 @param userId User ID which prepared values should be sent. If set to <tt>nil</tt> then current active user ID will be used.
 */
- (void)sendPreparedValuesForUserId:(NSString *)userId;

@end
