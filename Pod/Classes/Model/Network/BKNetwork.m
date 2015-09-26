//
//  BKNetwork.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
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
    NSString *urlString = [[baseURL stringByAppendingString:packet.relativeURL]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlAbsolute = [NSURL URLWithString:urlString];
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:urlAbsolute];
    
    // setup request
    [r setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [r setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [r setHTTPMethod:packet.HTTPMethod];
    
    // set body
    if (packet.body) {
        NSData *bodyData = [packet.body dataUsingEncoding:NSUTF8StringEncoding];
        
        [r setValue:[NSString stringWithFormat:@"%ld",
                     (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
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
