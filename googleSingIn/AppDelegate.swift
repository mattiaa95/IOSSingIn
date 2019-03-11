//
//  AppDelegate.swift
//  googleSingIn
//
//  Created by Mattia on 06/03/2019.
//  Copyright © 2019 Mattia. All rights reserved.

import UIKit
import GoogleSignIn
import FacebookCore
import TwitterKit
import LinkedinSwift

@UIApplicationMain
class AppDelegate:  UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
            || GIDSignIn.sharedInstance().handle(url as URL?,
                                                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            || TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        
        // Linkedin sdk handle redirect
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(application,
                                                   open: url,
                                                   sourceApplication: sourceApplication,
                                                   annotation: annotation
            )
        }
        
        return false
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "716695608022-p8eopqh79k7chjphbm6r39nussr0nn0b.apps.googleusercontent.com" // GOOGLE
        GIDSignIn.sharedInstance().delegate = self // GOOGLE
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) //Facebook
        TWTRTwitter.sharedInstance().start(withConsumerKey:"sKrqCoZG4byvW4ou3Y5Wzdk0W", consumerSecret:"cj6AyKMCUMHDHXS8cfDJ0T8TCYjkjgB5qCYGKG0bWMeGXbheOq") // Twitter
        return true
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            
            let idToken = user.authentication.idToken
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["token": idToken! ])
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["token": ""])
    }

}

