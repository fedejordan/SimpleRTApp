//
//  AppDelegate.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 24/2/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit
import TwitterKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pushNotificationsHandler: PushNotificationsActionsHandler? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let window = window {
            pushNotificationsHandler = PushNotificationsActionsHandler(withWindow: window)
            UNUserNotificationCenter.current().delegate = pushNotificationsHandler
        }
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "ConsumerKey", consumerSecret: "ConsumerSecret")
        registerForPushNotifications()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK:- Push notifications
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
            let retweetAction = UNNotificationAction(identifier: PushNotificationActionIdentifier.retweetActionIdentifier.rawValue, title: "Retweet", options: [.foreground])
            
            let retweetCategory = UNNotificationCategory(identifier: "RETWEET", actions: [retweetAction], intentIdentifiers: [], options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([retweetCategory])
            
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

}
