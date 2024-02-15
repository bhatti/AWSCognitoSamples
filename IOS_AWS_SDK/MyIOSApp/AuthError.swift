//
//  AuthError.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/8/24.
//

import Foundation

enum AuthError: Error {
    case signinIncomplete
    case error(NSError)
    
    func toString() -> String {
        switch self {
        case .signinIncomplete:
            return "Signin incomplete"
        case .error(let err):
            if let msg = err.userInfo["message"] {
                return "\(msg)"
            }
            return err.localizedDescription
        }
    }
}
