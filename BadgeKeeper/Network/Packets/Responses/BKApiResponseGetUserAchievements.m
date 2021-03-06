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

#import "BKApiResponseGetUserAchievements.h"
#import "BKUserAchievement.h"

@implementation BKApiResponseGetUserAchievements

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *list = [NSMutableArray new];
        id result = json[@"Result"];
        if (result != nil && result != [NSNull null]) {
            for (NSDictionary *item in result) {
                [list addObject:[[BKUserAchievement alloc] initWithJSON:item]];
            }
        }
        _achievements = list;
    }
    return self;
}

@end
