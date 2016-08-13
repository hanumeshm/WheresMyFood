//
//  YelpSearch.h
//  WheresMyFood
//
//  Created by Dinesh PS on 5/17/16.
//  Copyright © 2016 Dinesh PS. All rights reserved.
//
#import <YelpAPI/YLPSortType.h>

@class YLPSearch;
@class YLPCoordinate;

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLPSearchCompletionHandler)(YLPSearch *_Nullable search, NSError *_Nullable error);

@interface Search : NSObject  

- (void)searchWithLocation:(nullable NSString *)location
            currentLatLong:(nullable NSString *)cll
                      term:(nullable NSString *)term
                      sort:(YLPSortType)sort
         completionHandler:(void (^)(NSDictionary *jsonResponse, NSError *error)) completionHandler;

@end

NS_ASSUME_NONNULL_END