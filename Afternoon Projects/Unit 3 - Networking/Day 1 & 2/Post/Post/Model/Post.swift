//
//  Post.swift
//  Post
//
//  Created by Annicha on 13/5/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post: Codable {
    let text: String
    let timestamp: Date
    let username: String
    
    init(username: String, text: String, timeStamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = Date.init(timeIntervalSinceReferenceDate: timeStamp)
    }
}
