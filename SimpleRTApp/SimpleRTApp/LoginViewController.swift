//
//  ViewController.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 24/2/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    let hashtagsSegueIdentifier = "hashtagsViewControllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTwitterButton()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            self.performSegue(withIdentifier: hashtagsSegueIdentifier, sender: nil)
        }
    }

    private func addTwitterButton() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if let session = session {
                print("signed in as \(session.userName)");
                self.performSegue(withIdentifier: self.hashtagsSegueIdentifier, sender: nil)
            } else {
                let errorDescription = error?.localizedDescription ?? "unknown"
                print("error: \(errorDescription)");
            }
        })
        logInButton.center = self.view.center
        view.addSubview(logInButton)
    }
}

