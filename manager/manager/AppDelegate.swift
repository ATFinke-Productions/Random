//
//  AppDelegate.swift
//  manager
//
//  Created by Andrew Finke on 10/18/14.
//  Copyright (c) 2014 ATFinke Productions. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let version = 0

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        if let font = font {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : font]
        }
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 1.0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let predicate = NSPredicate(format: "version > %i", version)
        let query = CKQuery(recordType: "UTI", predicate: predicate)
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error) -> Void in
            if records.count > 0 {
                var defaults = NSUserDefaults.standardUserDefaults()
                var fileTypes = [String]()
                for record in records {
                    let identifier: String? = record.objectForKey("identifier") as? String
                    fileTypes.append(identifier!)
                }
                defaults.setObject(fileTypes, forKey: "NewFileTypes")
                defaults.synchronize()
            }
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.fileURL {
            var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            path = path.stringByAppendingPathComponent(url.lastPathComponent!)
            let pathURL = NSURL(fileURLWithPath: path)!
            NSFileManager.defaultManager().copyItemAtURL(url, toURL: pathURL, error: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("FilesUpdated", object: nil)
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

