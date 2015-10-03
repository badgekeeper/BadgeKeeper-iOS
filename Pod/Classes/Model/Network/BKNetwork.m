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

#pragma mark - Root

+ (void)initialize {
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                      defaultSessionConfiguration]];
}


#pragma mark - Common

+ (void)sendPacket:(BKNetPacket *)packet
         onSuccess:(BKNetworkCallbackSuccess)success
         onFailure:(BKNetworkCallbackFailure)failure {
    
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.host = @"api.badgekeeper.net";
    urlComponents.path = [packet pathURL];
    urlComponents.query = [packet queryURL];
    
    NSURL *urlAbsolute = [urlComponents URL];
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
    
    id handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
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
                NSError *jsonValidationError = [BKNetwork validateJsonResponse:json];
                if (jsonValidationError) {
                    failure(response, jsonValidationError);
                } else {
                    success(json, response);
                }
            }
        }
    };
    
    // launch data task
    [[session dataTaskWithRequest:r completionHandler:handler] resume];
}

+ (NSError *)validateJsonResponse:(NSDictionary *)response {
    id result = [response valueForKey:@"Result"];
    id error = [response valueForKey:@"Error"];

    // Generate internal server error (maybe should read "Message" from response)
    if (!result && !error) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Internal server error" forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"Server error." code:-1 userInfo:details];
    }
    // Read server error
    else if (error && error != [NSNull null]) {
        NSInteger const code = [[error valueForKey:@"Code"] integerValue];
        NSString *message = [error valueForKey:@"Message"];
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:message forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"Request error." code:code userInfo:details];
    }
    
    return nil;
}

@end
