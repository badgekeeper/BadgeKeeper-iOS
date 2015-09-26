//
//  BKNetPacket.h
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BKNetPacket : NSObject {
    
}

@property (readonly, nonatomic) NSString *relativeURL;
@property (readonly, nonatomic) NSString *body;
@property (readonly, nonatomic) NSString *HTTPMethod;


#pragma mark - Parsing

- (void)parseJSON:(id)json;

@end
