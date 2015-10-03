//
//  BKNetPacket.h
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BKNetPacket : NSObject {
    
}

@property (readonly, nonatomic) NSString *pathURL;
@property (readonly, nonatomic) NSString *queryURL;
@property (readonly, nonatomic) NSString *body;
@property (readonly, nonatomic) NSString *HTTPMethod;


#pragma mark - Parsing

- (void)parseJSON:(id)json;

@end
