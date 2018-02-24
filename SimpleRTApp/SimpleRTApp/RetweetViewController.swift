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

    @IBAction private func didSelectRetweet(sender: UIButton) {
        guard let tweetId = tweetIdTextField.text else { return }
        let client = TWTRAPIClient()
        client.loadTweet(withID: tweetId) { (tweet, error) -> Void in
            if let text = tweet?.text {
                self.showAlert(withText: text)
            } else {
                self.showAlert(withText: "Data not found")
            }
        }
    }
    
    private func showAlert(withText text: String) {
        let alert = UIAlertController(title: "Tweet example", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

}
