//
//  BKApiResponse.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 21.10.15.
//  Copyright © 2015 BadgeKeeper. All rights reserved.
//

#import "BKObject.h"

@class BKApiResponseError;

@interface BKApiResponse : BKObject {
    
}

// out
@property (readonly, nonatomic) BKApiResponseError *error;

@end
