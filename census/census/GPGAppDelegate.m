//
//  GPGAppDelegate.m
//  census
//
//  Created by Andrew on 10/18/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "GPGAppDelegate.h"

@implementation GPGAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	 
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"la"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"11" forKey:@"la"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tips" message:@"The labels in the middle of the screen indicate the age of the population in each bar. The blue is men and red is women. The labels in the bottom corners show how many people in one bar if it hit the edge of the screen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
