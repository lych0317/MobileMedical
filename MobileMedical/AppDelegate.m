
//  AppDelegate.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/20.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "Config.h"
#import "Constants.h"
#import "Utils.h"

#import "MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[DatabaseManager sharedManager] loadAllData];
    [self setupUMeng];
    return YES;
}

- (void)setupUMeng {
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:@"5460385cfd98c5c3bb00220e"];
    [MobClick updateOnlineConfig];
}

- (void)enterMainView {
    BOOL appEnable = [[MobClick getConfigParams:@"app_enable"] boolValue];
    if (!appEnable) {
        return;
    }

    [Utils saveToUserDefaultWithKey:USER_DEFAULT_KEY_ACCOUNT object:[Config sharedConfig].username];
    [Utils saveToUserDefaultWithKey:USER_DEFAULT_KEY_PASSWORD object:[Config sharedConfig].password];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DataDisplay" bundle:nil];
    UINavigationController *dataDisplay = [storyboard instantiateInitialViewController];

    storyboard = [UIStoryboard storyboardWithName:@"DataCollection" bundle:nil];
    UINavigationController *dataCollection = [storyboard instantiateInitialViewController];

    storyboard = [UIStoryboard storyboardWithName:@"StaffManager" bundle:nil];
    UINavigationController *staffManager = [storyboard instantiateInitialViewController];

    storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UINavigationController *setting = [storyboard instantiateInitialViewController];

    self.tabBarController = [[UITabBarController alloc] init];
    if ([[Config sharedConfig].usertype intValue] == 1) {
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:dataDisplay, dataCollection, staffManager, setting, nil];
    } else {
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:dataDisplay, dataCollection, setting, nil];
    }

    self.window.rootViewController = self.tabBarController;
}

- (void)exitMainView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountManager" bundle:nil];
    UINavigationController *accountManager = [storyboard instantiateInitialViewController];

    self.window.rootViewController = accountManager;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wanakamusic.MobileMedical" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MobileMedical" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MobileMedical.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
