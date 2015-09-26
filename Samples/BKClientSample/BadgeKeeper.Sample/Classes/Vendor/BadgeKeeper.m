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
#import "BKNetPacketGetProjectAchievements.h"
#import "BKNetPacketGetUserAchievements.h"
#import "BKNetPacketSetUserChanges.h"

// notifications
NSString *const kBKNotificationDidReceiveProjectAchievements = @"kBKNotificationDidReceiveProjectAchievements";
NSString *const kBKNotificationFailedReceiveProjectAchievements = @"kBKNotificationFailedReceiveProjectAchievements";
NSString *const kBKNotificationDidReceiveUserAchievements = @"kBKNotificationDidReceiveUserAchievements";
NSString *const kBKNotificationFailedReceiveUserAchievements = @"kBKNotificationFailedReceiveUserAchievements";
NSString *const kBKNotificationDidSendPreparedValues = @"kBKNotificationDidSendPreparedValues";
NSString *const kBKNotificationFailedSendPreparedValues = @"kBKNotificationFailedSendPreparedValues";

// notifications keys
NSString *const kBKNotificationKeyResponseObject = @"ResponseObject";
NSString *const kBKNotificationKeyErrorResponse = @"ErrorResponse";
NSString *const kBKNotificationKeyErrorObject = @"ErrorObject";

// callbacks
typedef void (^BadgeKeeperCallbackSendSuccess)(BKNetPacket *packet);


@interface BadgeKeeper () {
    NSMutableDictionary *usersValues;
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
        usersValues = [NSMutableDictionary new];
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

- (void)prepareValue:(double)value forAchievementId:(NSString *)achievementId {
    NSString *userId = self.userId;
    
    BKKeyValuePair *pair = [[BKKeyValuePair alloc] initWithKey:achievementId value:@(value)];
    // store pair
    if (![usersValues objectForKey:userId]) {
        [usersValues setObject:[NSMutableArray new] forKey:userId];
    }
    [usersValues[userId] addObject:pair];
}

- (void)sendPreparedValuesForUserId:(NSString *)userId {
    if (!userId) {
        userId = self.userId; // use active user ID if no user ID was specified
    }
    NSArray *pairs = [usersValues objectForKey:userId];
    NSAssert(pairs, @"User has no prepared values.");
    BKNetPacketSetUserChanges *pack = [BKNetPacketSetUserChanges new];
    
    pack.projectId = self.projectId;
    pack.userId = userId;
    pack.pairs = pairs;
    
    [self sendPacket:pack
           onSuccess:^(BKNetPacket *packet) {
                // remove prepared values
               [usersValues removeObjectForKey:((BKNetPacketSetUserChanges *)packet).userId];
               
               [self notify:kBKNotificationDidSendPreparedValues responseObject:packet];
           }
           onFailure:^(NSURLResponse *response, NSError *error) {
               [self notifyError:kBKNotificationFailedSendPreparedValues
                        response:response
                           error:error];
           }];
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
    [[NSNotificationCenter defaultCenter]
     postNotificationName:notificationName
     object:self
     userInfo:@{kBKNotificationKeyResponseObject : object}];
}

- (void)notifyError:(NSString *)notificationName
           response:(NSURLResponse *)response
              error:(NSError *)error {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:notificationName
     object:self
     userInfo:@{kBKNotificationKeyErrorResponse : response,
                kBKNotificationKeyErrorObject : error}];
}

@end
