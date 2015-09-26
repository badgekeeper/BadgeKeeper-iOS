//
//  BKProjectAchievement.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import "BKObject.h"


@interface BKProjectAchievement : BKObject {
    
}

@property (readonly, nonatomic) NSString *displayName;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSData   *iconUnlocked;
@property (readonly, nonatomic) NSData   *iconLocked;

@end
