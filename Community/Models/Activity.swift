//
//  Activity.swift
//  Community
//
//  Created by Blake Anderson on 12/21/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import Firebase

struct Activity {
    
    var author: String!
    var date: Date!
    var type: Int!
    var body: String!
    var commentCount: Int!
    
    init(dictionary: [String:Any]) {
        
        if let author = dictionary["author"] as? String {
            self.author = author
        }
        if let type = dictionary["type"] as? Int {
            self.type = type
        }
        if let body = dictionary["body"] as? String {
            self.body = body
        }
        if let date = dictionary["date"] as? Timestamp {
            self.date = date.dateValue()
        }
        if let commentCount = dictionary["commentCount"] as? Int {
            self.commentCount = commentCount
        }
    }
}
