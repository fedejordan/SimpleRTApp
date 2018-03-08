//
//  NetworkManager.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 7/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

import Alamofire

class NetworkManager: NSObject {

    private enum NetworkPath: String {
        case tweetRequest
        case postedTweet
        
        static let baseURL = "http://localhost:3000/"
        
        var url: String {
            return NetworkPath.baseURL + self.rawValue
        }
    }
    
    private struct NetworkParameter {
        static let deviceToken = "deviceToken"
        static let hashtags = "hashtags"
        static let tweetRequestId = "tweetRequestId"
        static let tweetId = "tweetId"
    }
    
    // MARK:- TweetRequest services
    func getTweetRequest(byId tweetRequestId: String, completion: @escaping (TweetRequest?) -> Void) {
        let urlString = NetworkPath.tweetRequest.url + "/" + tweetRequestId
        Alamofire.request(urlString).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let tweetRequest = try decoder.decode(TweetRequest.self, from: data)
                completion(tweetRequest)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    func postTweetRequest(forDeviceToken deviceToken: String, hashtags: String, completion: @escaping (TweetRequest?) -> Void) {
        let urlString = NetworkPath.tweetRequest.url
        let parameters = [NetworkParameter.deviceToken: deviceToken,
                          NetworkParameter.hashtags: hashtags]
        Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let tweetRequest = try decoder.decode(TweetRequest.self, from: data)
                completion(tweetRequest)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    func deleteTweetRequest(byId tweetRequestId: String, completion: @escaping (Bool) -> Void) {
        let urlString = NetworkPath.tweetRequest.url + "/" + tweetRequestId
        Alamofire.request(urlString, method: .delete).responseString { response in
            completion(response.result.isSuccess)
        }
    }
    
    // MARK:- PostedTweet services
    func postPostedTweet(forTweetRequestId tweetRequestId: String, tweetId: String, completion: @escaping (Bool) -> Void) {
        let urlString = NetworkPath.postedTweet.url
        let parameters = [NetworkParameter.tweetRequestId: tweetRequestId,
                          NetworkParameter.tweetId: tweetId]
        Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
            completion(response.result.isSuccess)
        }
    }
}
