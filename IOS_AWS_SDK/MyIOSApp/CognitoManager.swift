//
//  CognitoManager.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import Foundation
import os
import AWSCognitoIdentityProvider

class CognitoManager: ObservableObject {
    var userPool: AWSCognitoIdentityUserPool?

    init() {
        let serviceConfiguration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: nil)
        let userPoolID = Bundle.main.object(forInfoDictionaryKey: "UserPoolID") as! String
        let clientID = Bundle.main.object(forInfoDictionaryKey: "ClientID") as! String
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientID, clientSecret: nil, poolId: userPoolID)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "UserPool")
        self.userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
    }

    func signUp(username: String, password: String, email: String, 
                completion: @escaping (Result<Bool, AuthError>) -> Void) {
        let emailAttribute = AWSCognitoIdentityUserAttributeType(name: "email", value: email)
        userPool?.signUp(username, password: password, userAttributes: [emailAttribute], validationData: nil).continueWith { (task) -> AnyObject? in
            DispatchQueue.main.async {
                if let error = task.error {
                    completion(.failure(AuthError.error(error as NSError)))
                } else {
                    completion(.success(true))
                }
            }
            return nil
        }
    }

    func confirmSignUp(username: String, confirmationCode: String,
                       completion: @escaping (Result<Bool, AuthError>) -> Void) {
        let user = self.userPool?.getUser(username)
        user?.confirmSignUp(confirmationCode).continueWith { (task) -> AnyObject? in
            DispatchQueue.main.async {
                if let error = task.error {
                    completion(.failure(AuthError.error(error as NSError)))
                } else {
                    completion(.success(true))
                }
            }
            return nil
        }
    }

    func signIn(username: String, password: String,
                completion: @escaping (Result<User, AuthError>) -> Void) {
        let user = self.userPool?.getUser(username)

        user?.getSession(username, password: password, validationData: nil).continueWith { (task) -> AnyObject? in
            DispatchQueue.main.async {
                if let error = task.error {
                    completion(.failure(AuthError.error(error as NSError)))
                } else {
                    completion(.success(
                        User(username: username, claims:
                                (task.result?.accessToken?.tokenClaims ??
                                         task.result?.idToken?.tokenClaims)!)))
                }
            }
            return nil
        }
    }
}
