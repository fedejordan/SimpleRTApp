//
//  HashtagsViewController.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 8/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import UIKit

class HashtagsViewController: UIViewController {

    @IBOutlet private weak var hashtagsLabel: UILabel!
    @IBOutlet private weak var mainActionButton: UIButton!
    
    private var actualTweetRequestId: String? = nil
    private var deviceToken: String = "FakeDeviceToken"
    
    private enum MainAction {
        case addHashtags
        case deleteHashtags
    }
    
    private var mainAction: MainAction = .addHashtags
    private let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actualTweetRequestId = getTweetRequestIdFromPreferences()
        setupInterface()
    }
    
    // MARK:- Interface
    private func setupInterface() {
        if let tweetRequestId = actualTweetRequestId {
            mainActionButton.setTitle("Delete", for: .normal)
            mainAction = .deleteHashtags
            getHashtags(forTweetRequestId: tweetRequestId)
        } else {
            mainActionButton.setTitle("Add", for: .normal)
            mainAction = .addHashtags
        }
    }
    
    // MARK:- Actions
    @IBAction private func didTapMainAction(sender: UIButton) {
        switch mainAction {
        case .addHashtags:
            askHashtags()
        case .deleteHashtags:
            confirmDeleteHashtags()
        }
    }
    
    private func askHashtags() {
        let alertController = UIAlertController(title: "Which hashtags do you want to see?", message: "Write your favorite hashtags", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "#example"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let hashtags = alertController.textFields?.first?.text {
                self.save(hashtags: hashtags)
            } else {
                self.showError()
            }
        }
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func confirmDeleteHashtags() {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete the hashtags?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.deleteHashtags()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showError() {
        let alertController = UIAlertController(title: "Error", message: "There was an error in last operation", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK:- Network calls
    private func getHashtags(forTweetRequestId tweetRequestId: String) {
        networkManager.getTweetRequest(byId: tweetRequestId) { (tweetRequest) in
            if let hashtags = tweetRequest?.hashtags {
                self.hashtagsLabel.text = hashtags
            } else {
                self.actualTweetRequestId = nil
                self.setupInterface()
                self.showError()
            }
        }
    }
    
    private func save(hashtags: String) {
        networkManager.postTweetRequest(forDeviceToken: deviceToken, hashtags: hashtags) { (tweetRequest) in
            if let tweetRequestId = tweetRequest?.tweetRequestId {
                let tweetRequestIdString = "\(tweetRequestId)"
                self.actualTweetRequestId = tweetRequestIdString
                self.saveInPreferences(tweetRequestId: tweetRequestIdString)
                self.hashtagsLabel.text = hashtags
            } else {
                self.showError()
            }
        }
    }
    
    private func deleteHashtags() {
        guard let tweetRequestId = actualTweetRequestId else {
            showError()
            return
        }
        
        networkManager.deleteTweetRequest(byId: tweetRequestId) { (success) in
            if success {
                self.hashtagsLabel.text = "No hashtags. Add one!"
            } else {
                self.showError()
            }
        }
    }
    
    // MARK:- Preferences
    private func saveInPreferences(tweetRequestId: String) {
        let defaults = UserDefaults.standard
        defaults.set(tweetRequestId, forKey: "tweet_request_id")
    }
    
    private func getTweetRequestIdFromPreferences() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "tweet_request_id")
    }
}
