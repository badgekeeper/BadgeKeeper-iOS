//
//  BKApiResponseGetUserAchievements.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 22.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKApiResponse.h"

@interface BKApiResponseGetUserAchievements : BKApiResponse {
    
}

// out
@property (readonly, nonatomic) NSArray *achievements;

@end
