//
//  PushNotificationsActionsHandler.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 18/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit
import UserNotifications

enum PushNotificationActionIdentifier: String {
    case retweetActionIdentifier = "retweet_action_identifier"
}

class PushNotificationsActionsHandler: NSObject {

    let window: UIWindow
    
    init(withWindow window: UIWindow) {
        self.window = window
        super.init()
    }
}

extension PushNotificationsActionsHandler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if response.actionIdentifier == PushNotificationActionIdentifier.retweetActionIdentifier.rawValue {
            guard let tweetId = userInfo["tweetId"] as? String else { return }
            openViewAndRetweet(fromTweetId: tweetId)
        }
        
        completionHandler()
    }
    
    private func openViewAndRetweet(fromTweetId tweetId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let retweetViewController = storyboard.instantiateViewController(withIdentifier: "retweetViewController") as? RetweetViewController
        
        if let retweetViewController = retweetViewController {
            retweetViewController.setupAutomaticRetweet(withTweetId: tweetId)
           
            let hashtagsViewController = window.rootViewController?.presentedViewController
            
            if let presentedRetweetViewController = hashtagsViewController?.presentedViewController {
                
                presentedRetweetViewController.dismiss(animated: false, completion: {
                    hashtagsViewController?.present(retweetViewController, animated: true)
                })
            } else {
                hashtagsViewController?.present(retweetViewController, animated: true)
            }
            
        }
    }
    
}
