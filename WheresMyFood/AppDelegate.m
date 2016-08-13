//
//  AppDelegate.m
//  WheresMyFood
//
//  Created by Dinesh PS on 5/17/16.
//  Copyright © 2016 Dinesh PS. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "FavoritesViewController.h"
#import "CustomTabBarController.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyBvp-c7sxqDxIsCLT_2zYWwT_1kezi_cFE"];
    SearchViewController *searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchView.tabBarItem.title = @"Search";
    UINavigationController *navSearch = [[UINavigationController alloc] initWithRootViewController:searchView];
    FavoritesViewController *favoritesView = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
    favoritesView.tabBarItem.title = @"Favorites";
    UINavigationController *navFavorite = [[UINavigationController alloc] initWithRootViewController:favoritesView];
    CustomTabBarController *tabBar = [[CustomTabBarController alloc] init];
    tabBar.viewControllers = [NSMutableArray arrayWithObjects:navSearch, navFavorite, nil];
    tabBar.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    self.window.rootViewController = tabBar;
    [[self window] makeKeyAndVisible];
    return YES;
}

- (void)addRestaurantusingDictionary: (NSDictionary *) restaurantInfo {
    NSMutableArray *temp1;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FAVORITE_RESTAURANTS"]) {
        NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"FAVORITE_RESTAURANTS"];
        temp1 = [[NSMutableArray alloc] initWithArray:temp];
    }
    else
        temp1 = [[NSMutableArray alloc] init];
    [temp1 addObject:restaurantInfo[@"id"]];
    [[NSUserDefaults standardUserDefaults] setObject:temp1 forKey:@"FAVORITE_RESTAURANTS"];
    [[NSUserDefaults standardUserDefaults] setObject:restaurantInfo forKey:restaurantInfo[@"id"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeRestaurantusingID: (NSString *) restaurantID {
    NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"FAVORITE_RESTAURANTS"];
    NSMutableArray *temp1 = [[NSMutableArray alloc] initWithArray:temp];
    [temp1 removeObject:restaurantID];
    [[NSUserDefaults standardUserDefaults] setObject:temp1 forKey:@"FAVORITE_RESTAURANTS"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:restaurantID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)restaurantsCount {
    NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"FAVORITE_RESTAURANTS"];
    if(temp) {
        return [temp count];
    }
    return 0;
}

- (NSMutableDictionary *)restaurantAtIndex: (NSInteger) index {
    NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"FAVORITE_RESTAURANTS"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:[temp objectAtIndex:index]];
}

- (bool)isFavoriteRestaurant: (NSString *) restaurantID {
    if([[NSUserDefaults standardUserDefaults] objectForKey:restaurantID])
        return YES;
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WheresMyFood" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WheresMyFood.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)launchApplication {
    
}

@end
