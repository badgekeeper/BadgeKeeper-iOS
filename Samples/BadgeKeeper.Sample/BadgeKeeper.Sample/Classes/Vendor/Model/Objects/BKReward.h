//
//  BKReward.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKObject.h"

@interface BKReward : BKObject {
    
}

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) double    value;

@end
