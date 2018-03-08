//
//  TweetRequest.swift
//  SimpleRTApp
//
//  Created by Federico Jordán on 7/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

struct TweetRequest: Codable {
    
    let tweetRequestId: Int?
    let deviceToken: String?
    let hashtags: String?
    
    private enum CodingKeys: String, CodingKey {
        case tweetRequestId = "id"
        case deviceToken = "device_token"
        case hashtags
    }

}
