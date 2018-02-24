//
//  RetweetViewController.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 24/2/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit

class RetweetViewController: UIViewController {

    @IBOutlet private weak var tweetIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func didSelectRetweet(sender: UIButton) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
