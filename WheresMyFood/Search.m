//
//  YelpSearch.m
//  WheresMyFood
//
//  Created by Dinesh PS on 5/17/16.
//  Copyright © 2016 Dinesh PS. All rights reserved.
//

#import "Search.h"
#import <YLPCoordinate.h>
#import <TDOAuth/TDOAuth.h>

@implementation Search


- (void)searchWithLocation:(nullable NSString *)location
            currentLatLong:(nullable NSString*)cll
                      term:(nullable NSString *)term
                      sort:(YLPSortType)sort
         completionHandler:(void (^)(NSDictionary *jsonResponse, NSError *error)) completionHandler {
    
    // Set Parameters
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"limit"] = [NSNumber numberWithInt:20];
    params[@"offset"] = [NSNumber numberWithInt:0];
    params[@"radius_filter"] = [NSNumber numberWithInt:32200];
    if (location) {
        params[@"location"] = location;
    }
    if (cll) {
        params[@"cll"] = cll;
    }
    if (term) {
        params[@"term"] = term;
    }
    if (sort) {
        params[@"sort"] = [NSNumber numberWithInteger:sort];
    }
    NSLog(@"Params: %@", params);
    // Set Request Data
    NSURLRequest *request =    [TDOAuth URLRequestForPath:@"/v2/search/"
                                            GETParameters:params
                                                   scheme:@"https"
                                                     host:@"api.yelp.com"
                                              consumerKey:@"YMZz1L6KJph7FsAmPbm63Q"
                                           consumerSecret:@"NzvnI9IMAGNEMxUARHlC8ijOBu4"
                                              accessToken:@"DI4z203f7hjOecTNg1EWVzYWlLtRH0aW"
                                              tokenSecret:@"Ec2eDDHuu8o0_3HW6EAMLJaLI2E"];
    
    // Get Response
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseJSON;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (!error) {
            responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        }
        
        if (!error && httpResponse.statusCode == 200) {
            completionHandler(responseJSON, nil);
        } else {
            error = error ? error : [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:httpResponse.statusCode userInfo:responseJSON];
            completionHandler(nil, error);
        }
    }] resume];

}

@end
