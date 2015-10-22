//
//  BKAchievement.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"

@interface BKAchievement : BKObject {
    
}

@property (readonly, nonatomic) NSString *displayName;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *iconUnlocked;
@property (readonly, nonatomic) NSString *iconLocked;

@end
