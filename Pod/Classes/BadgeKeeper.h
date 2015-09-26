/*
 
 BadgeKeeper
 
 The MIT License (MIT)
 
 Copyright (c) 2015 BadgeKeeper
 
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

@class BadgeKeeper;


@protocol BadgeKeeperDelegate<NSObject>
@optional
- (void)client:(BKClient *)client didLoadProjectAchievements:(NSArray *)achievements;
- (void)client:(BKClient *)client didLoadUserAchievements:(NSArray *)achievements;
- (void)client:(BKClient *)client didFailWithError:(NSError *)error;

@end


/// Manages BadgeKeeper service environment.
@interface BadgeKeeper : NSObject {
    
}
/// Active project ID from the BadgeKeeper service.
@property (readonly, nonatomic) NSString *projectId;
/// Indicates whether all next requests should load locked/unlocked icons for the achievements.
@property (assign, nonatomic) BOOL shouldLoadIcons;
/// Delegate that can react to BKClient state changes.
@property (weak, nonatomic) id<BKClientDelegate> delegate;


#pragma mark - Root

+ (instancetype)instance;


#pragma mark - Setup

/// Sets your project ID in the BadgeKeeper service. Must be called once before performing any other actions.
- (void)setProjectId:(NSString *)projectId;


#pragma mark - Service

- (void)requestProjectAchievements;
- (void)requestUserAchievementsWithUserId:(NSString *)userId;
- (void)prepareValue:(double)value forAchievementId:(NSString *)achievementId userId:(NSString *)userId;
- (void)sendValuesWithUserId:(NSString *)userId;

@end
