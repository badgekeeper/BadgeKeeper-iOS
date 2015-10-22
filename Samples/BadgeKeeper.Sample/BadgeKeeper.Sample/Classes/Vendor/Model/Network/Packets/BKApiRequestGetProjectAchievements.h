//
//  BKApiRequestGetProjectAchievements.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiRequest.h"

@interface BKApiRequestGetProjectAchievements : BKApiRequest {
    
}

// in
@property (copy, nonatomic) NSString *projectId;
@property (nonatomic) BOOL shouldLoadIcons;

@end
