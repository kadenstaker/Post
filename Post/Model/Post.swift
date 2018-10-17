//
//  Post.swift
//  Post
//
//  Created by Kaden Staker on 10/15/18.
//  Copyright © 2018 Kaden Staker. All rights reserved.
//

import Foundation

struct Post: Codable {
    let username: String
    let text: String
    let timestamp: TimeInterval
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
}


