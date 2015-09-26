//
//  BKObject.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BKObject : NSObject {
    
}

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
