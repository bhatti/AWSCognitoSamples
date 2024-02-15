//
//  User.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/12/24.
//

import Foundation

struct User {
    let username: String
    let claims: [String: Any]
    
    init(username: String, claims: [String : Any]) {
        self.username = username
        self.claims = claims
    }
}
