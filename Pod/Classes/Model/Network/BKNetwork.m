//
//  BKNetwork.m
//  BKClientSample
//
//  Created by Георгий Малюков on 19.07.15.
//  Copyright (c) 2015 BadgeKeeper. All rights reserved.
//

#import "BKNetwork.h"


@implementation BKNetwork

static NSURLSession *session = nil;
NSString *const baseURL = @"https://api.badgekeeper.net/";


#pragma mark - Root

+ (void)initialize {
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                      defaultSessionConfiguration]];
}


#pragma mark - Common

+ (void)sendPacket:(BKNetPacket *)packet
         onSuccess:(BKNetworkCallbackSuccess)success
         onFailure:(BKNetworkCallbackFailure)failure {
    NSURL *urlAbsolute = [NSURL URLWithString:[baseURL stringByAppendingString:packet.relativeURL]];
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:urlAbsolute];
    
    // setup request
    [r setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [r setHTTPMethod:packet.HTTPMethod];
    
    // set body
    if (packet.body) {
        NSData *bodyData = [packet.body dataUsingEncoding:NSUTF8StringEncoding];
        [r setValue:[NSString stringWithFormat:@"%ld",
                     bodyData.length] forHTTPHeaderField:@"Content-Length"];
        [r setHTTPBody:bodyData];
    }
    // launch data task
    [[session dataTaskWithRequest:r
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error) {
                        failure(response, error);
                    }
                    else {
                        NSError *jsonError = nil;
                        NSDictionary *json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                              error:&jsonError];
                        if (jsonError) {
                            failure(response, jsonError);
                        }
                        else {
                            success(json, response);
                        }
                    }
                }]
     resume];
}

@end
