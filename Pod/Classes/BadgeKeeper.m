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

#import "BadgeKeeper.h"
#import "BKNetwork.h"
#import "BKNetPacketGetProjectAchievements.h"
#import "BKNetPacketGetUserAchievements.h"

typedef void (^BKClientCallbackSendSuccess)(BKNetPacket *packet);


@interface BadgeKeeper () {
    NSMutableDictionary *users;
}

#pragma mark - Private

- (void)sendPacket:(BKNetPacket *)packet onSuccess:(BKClientCallbackSendSuccess)success;

@end


@implementation BadgeKeeper


#pragma mark - Root

- (instancetype)init {
    NSAssert(NO, @"Use 'instance' instead.");
    return nil;
}

- (instancetype)initPrivate {
    return [super init];
}

+ (instancetype)instance {
    static BadgeKeeper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initPrivate];
    });
    return instance;
}


#pragma mark - Setup

- (void)setProjectId:(NSString *)projectId {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _projectId = [projectId copy];
    });
}


#pragma mark - Service

- (void)requestProjectAchievements {
    BKNetPacketGetProjectAchievements *packet = [BKNetPacketGetProjectAchievements new];
    
    packet.projectId = self.projectId;
    packet.shouldLoadIcons = self.shouldLoadIcons;
    
    [self sendPacket:packet
           onSuccess:^(BKNetPacket *packet) {
               if ([self.delegate
                    respondsToSelector:@selector(client:didLoadProjectAchievements:)]) {
                   BKNetPacketGetProjectAchievements *pack = (BKNetPacketGetProjectAchievements *)packet;
                   [self.delegate client:self didLoadProjectAchievements:pack.achievements];
               }
           }];
}

- (void)requestUserAchievementsWithUserId:(NSString *)userId {
    BKNetPacketGetUserAchievements *packet = [BKNetPacketGetUserAchievements new];
    
    packet.projectId = self.projectId;
    packet.userId = userId;
    packet.shouldLoadIcons = self.shouldLoadIcons;
    
    [self sendPacket:packet
           onSuccess:^(BKNetPacket *packet) {
               if ([self.delegate
                    respondsToSelector:@selector(client:didLoadUserAchievements:)]) {
                   BKNetPacketGetUserAchievements *pack = (BKNetPacketGetUserAchievements *)packet;
                   [self.delegate client:self didLoadUserAchievements:pack.achievements];
               }
           }];
}

- (void)prepareValue:(double)value forAchievementId:(NSString *)achievementId userId:(NSString *)userId {
    BKKeyValuePair *pair = [[BKKeyValuePair alloc] initWithKey:achievementId value:@(value)];
    // store pair
    if (![users objectForKey:userId]) {
        [users setObject:[NSMutableArray new] forKey:userId];
    }
    [users[userId] addObject:pair];
}

- (void)sendValuesWithUserId:(NSString *)userId {
    // ...
}


#pragma mark - Private

- (void)sendPacket:(BKNetPacket *)packet onSuccess:(BKClientCallbackSendSuccess)success {
    [BKNetwork sendPacket:packet
                onSuccess:^(id json, NSURLResponse *response) {
                    [packet parseJSON:json];
                    
                    success(packet);
                }
                onFailure:^(NSURLResponse *response, NSError *error) {
                    if ([self.delegate respondsToSelector:@selector(client:didFailWithError:)]) {
                        [self.delegate client:self didFailWithError:error];
                    }
                }];
}

@end
