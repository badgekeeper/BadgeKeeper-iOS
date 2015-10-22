//
//  BKApiService.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKApiService.h"
#import "BKApiResponse.h"
#import "BKApiResponseError.h"

@implementation BKApiService

static NSURLSession *session = nil;
static const int INTERNAL_SERVER_ERROR = -1;
static const int PARSING_JSON_ERROR    = -2;

#pragma mark - Root

+ (void)initialize {
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                      defaultSessionConfiguration]];
}


#pragma mark - Common

+ (void)sendRequest:(BKApiRequest *)request
          onSuccess:(BKSuccessResponseCallback)success
          onFailure:(BKFailureResponseCallback)failure {
    
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.host = @"api.badgekeeper.net";
    urlComponents.path = [request pathURL];
    urlComponents.query = [request queryURL];
    
    NSURL *urlAbsolute = [urlComponents URL];
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:urlAbsolute];
    
    // setup request
    [r setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [r setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [r setHTTPMethod:request.HTTPMethod];
    
    // set body
    if (request.body) {
        NSData *bodyData = [request.body dataUsingEncoding:NSUTF8StringEncoding];
        [r setHTTPBody:bodyData];
        
        unsigned long const bodyLength = (unsigned long)bodyData.length;
        NSString *stringBodyLength = [NSString stringWithFormat:@"%ld", bodyLength];
        [r setValue:stringBodyLength forHTTPHeaderField:@"Content-Length"];
    }
    
    id handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) {
                failure(INTERNAL_SERVER_ERROR, error.localizedDescription);
            }
        }
        else {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingAllowFragments
                                  error:&jsonError];
            if (jsonError) {
                if (failure) {
                    failure(PARSING_JSON_ERROR, jsonError.localizedDescription);
                }
            }
            else {
                success(json);
            }
        }
    };
    
    // launch data task
    [[session dataTaskWithRequest:r completionHandler:handler] resume];
}

@end
