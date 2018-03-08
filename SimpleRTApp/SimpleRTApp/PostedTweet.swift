//
//  PostedTweet.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 8/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

struct PostedTweet: Codable {

    let postedTweetId: Int?
    let tweetRequestId: Int?
    let tweetId: String?
    
    private enum CodingKeys: String, CodingKey {
        case postedTweetId = "id"
        case tweetRequestId = "tweet_request_id"
        case tweetId = "tweet_id"
    }
    
}
