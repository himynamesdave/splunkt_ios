//
//  AppDelegate.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var loginController: LoginViewController!
    var storyBoard: UIStoryboard!
    
    
     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Mint Splunk 
        Mint.sharedInstance().enableMintLoggingCache(true)
        
        Mint.sharedInstance().enableLogging(true)
        
        Mint.sharedInstance().setLogging(8)

        Mint.sharedInstance().initAndStartSession("bb73e47a")
        //
        
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        ///
        let version:NSString = UIDevice.currentDevice().systemVersion as NSString;
        
        if (version.doubleValue >= 8.0){
            
            let types = UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge
            
            var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
            
            application.registerUserNotificationSettings( settings )
            application.registerForRemoteNotifications()
            
        }
        else{
            
            application.registerForRemoteNotificationTypes( UIRemoteNotificationType.Badge |
                UIRemoteNotificationType.Sound |
                UIRemoteNotificationType.Alert )
            
        }
       
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
        loadLoginView();
        
        styleElements()
        
        window!.makeKeyAndVisible()
        
        return true
    }
    
    
    func dismissSettings(){
        self.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    
    func styleElements(){
        
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // loadNotifications()
        
        NSLog(" didReceiveRemoteNotification ")
        
        var push = userInfo as NSDictionary
      
    }
    
 
    
    func loadLoginView(){
        
        let loginNavigationController = storyBoard.instantiateViewControllerWithIdentifier("loginNavigationController") as! UINavigationController
        loginController = loginNavigationController.topViewController as! LoginViewController
        
        UIView.transitionWithView(self.window!,
            duration:0.325,
            options:UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self.window!.rootViewController = loginNavigationController
                
            },
            completion: { (fininshed: Bool) -> () in
                
        })
        
    }
    
    
}


