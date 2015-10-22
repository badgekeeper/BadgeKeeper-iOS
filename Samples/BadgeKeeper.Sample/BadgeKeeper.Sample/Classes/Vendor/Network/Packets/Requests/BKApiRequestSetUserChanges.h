//
//  BKApiRequestSetUserChanges.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiRequest.h"

@interface BKApiRequestSetUserChanges : BKApiRequest {
    
}

// in
@property (copy, nonatomic)   NSString *projectId;
@property (copy, nonatomic)   NSString *userId;
@property (strong, nonatomic) NSArray  *pairs;

@end
