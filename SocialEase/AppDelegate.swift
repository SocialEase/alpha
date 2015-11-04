//
//  AppDelegate.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager! = CLLocationManager()
    var deviceTokenForPush: NSData? = nil
    var deviceLocation: CLLocation? = nil
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // set prase api keys
        Parse.setApplicationId("ZoRlR0MyiOwJcLH420YfdSZX4KkgM7m8BqhC7j2x", clientKey: "PTHMqglJowgpo9uy45chEBBbmiSzUuln3YDn3Vso")
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // register for push notifications
        // TODO: we should perhaps do this only after getting confirmation from user
        registerForPushNotifications(application, launchOptions: launchOptions)
        
        // initialize Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
        
//        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Set default theme for navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.sea_primaryColor()
        UINavigationBar.appearance().tintColor = UIColor.sea_primaryLightTextColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.sea_primaryLightTextColor()]
        
        // check user session here, if the session exists then send user directly to landing page else to register page
        let appFlow = AppFlow()
        if (User.currentUser == nil) {
            appFlow.presentLogin()
            return true
        }

        // Extract the notification data
        var planId : String?
        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            planId = getPlanIdFromNotificationPayload(notificationPayload)
        }

        if let planId = planId {
            appFlow.presentPlanViewControllerByFetchingPlanId(planId)
        } else {
            appFlow.presentHomePageViewController()
        }
        
        return true
    }
    
    func getPlanIdFromNotificationPayload(notificationPayload : NSDictionary) -> String? {
        let planId = notificationPayload["planId"] as? NSString
        return (planId != nil)
            ? String(planId!)
            : nil
    }

    func getAlertFromNotificationPayload(notificationPayload : NSDictionary) -> String? {
        let alert = notificationPayload["alert"] as? NSString
        return (alert != nil)
            ? String(alert!)
            : nil
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
    
    // PUSH NOTIFICATIONS
    func registerForPushNotifications(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
        }
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        deviceTokenForPush = deviceToken
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    func addUserToPushInstallation(user: PFUser?) {
        if (deviceTokenForPush != nil && user != nil) {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.setDeviceTokenFromData(deviceTokenForPush)
            currentInstallation["userId"] = user!.objectId!
            currentInstallation.saveInBackground()
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }

        //1. Create the alert controller.
        let alert = UIAlertController(title: getAlertFromNotificationPayload(userInfo), message: "View plan?", preferredStyle: .Alert)

        //2. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Sure", style: .Default, handler: { (action) -> Void in
            if let planId = self.getPlanIdFromNotificationPayload(userInfo) {
                let appFlow = AppFlow()
                appFlow.presentPlanViewControllerByFetchingPlanId(planId)
            }
        }))

        alert.addAction(UIAlertAction(title: "Later", style: .Default, handler: nil))

        //3. Present the alert.
        window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)


    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations[0]
        deviceLocation = location
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func logout() {
        PFInstallation.currentInstallation().removeObjectForKey("user")
        PFInstallation.currentInstallation().saveInBackground()
    }
}

