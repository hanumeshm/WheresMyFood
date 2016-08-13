//
//  AppDelegate.h
//  WheresMyFood
//
//  Created by Dinesh PS on 5/17/16.
//  Copyright © 2016 Dinesh PS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *restaurantList;
@property (nonatomic) int curInd;
@property (nonatomic) int curFavoriteInd;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)addRestaurantusingDictionary: (NSDictionary *) restaurantInfo;
- (void)removeRestaurantusingID: (NSString *) restaurantID;
- (bool)isFavoriteRestaurant: (NSString *) restaurantID;
- (NSMutableDictionary *)restaurantAtIndex: (NSInteger) index;
- (NSUInteger)restaurantsCount;

@end

