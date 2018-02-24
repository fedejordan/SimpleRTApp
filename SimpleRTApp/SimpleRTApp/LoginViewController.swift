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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTwitterButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    private func addTwitterButton() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if let session = session {
                print("signed in as \(session.userName)");
                self.performSegue(withIdentifier: "retweetViewControllerSegue", sender: nil)
            } else {
                let errorDescription = error?.localizedDescription ?? "unknown"
                print("error: \(errorDescription)");
            }
        })
        logInButton.center = self.view.center
        view.addSubview(logInButton)
    }
}

