//
//  RetweetViewController.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 24/2/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit
import TwitterKit

class RetweetViewController: UIViewController {

    @IBOutlet private weak var tweetIdTextField: UITextField!

    let client = TWTRAPIClient.withCurrentUser()
    
    @IBAction private func didSelectRetweet(sender: UIButton) {
        guard let tweetId = tweetIdTextField.text else { return }
        client.loadTweet(withID: tweetId) { (tweet, error) -> Void in
            if let text = tweet?.text {
                self.showRetweetAlert(withText: text)
            } else {
                self.showSimpleAlert(withText: "Data not found")
            }
        }
    }
    
    private func showSimpleAlert(withText text: String) {
        let alert = UIAlertController(title: "SimpleRTApp", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showRetweetAlert(withText text: String) {
        let alert = UIAlertController(title: "Tweet example", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let retweetAction = UIAlertAction(title: "Retweet", style: .default) { (action) in
            self.retweet()
        }
        alert.addAction(okAction)
        alert.addAction(retweetAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func retweet() {
        guard let tweetId = tweetIdTextField.text else { return }
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweet/" + tweetId + ".json"
        let params = ["id": tweetId]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "POST", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError)")
                self.showSimpleAlert(withText: "Retweet error")
            } else {
                self.savePostedTweet(forTweetId: tweetId, tweetRequestId: "1234")
            }
        }
    }
    
    private func savePostedTweet(forTweetId tweetId: String, tweetRequestId: String) {
        let networkManager = NetworkManager()
        networkManager.postPostedTweet(forTweetRequestId: tweetRequestId, tweetId: tweetId) { (success) in
            if success {
                self.showSimpleAlert(withText: "Retweet done!")
            } else {
                self.showSimpleAlert(withText: "Error saving posted tweet in server")
            }
        }
    }

}
