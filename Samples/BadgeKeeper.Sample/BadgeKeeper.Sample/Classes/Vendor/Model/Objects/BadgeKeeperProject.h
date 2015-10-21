//
//  BadgeKeeperProject.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BadgeKeeperObject.h"

@interface BadgeKeeperProject : BadgeKeeperObject {
    
}

@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *icon;
@property (readonly, nonatomic) NSArray *achievements;

@end
