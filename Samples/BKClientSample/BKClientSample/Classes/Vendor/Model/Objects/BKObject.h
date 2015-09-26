//
//  BKObject.h
//  BKClientSample
//
//  Created by Georgiy Malyukov on 19.07.15.
//  Copyright (c) 2015 Georgiy Malyukov, BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BKObject : NSObject {
    
}

#pragma mark - Root

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
