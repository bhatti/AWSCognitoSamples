//
//  CognitoManager.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import Foundation
import os
import Amplify
import AWSCognitoAuthPlugin


class CognitoManager: ObservableObject {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
           } catch {
               print("Failed to initialize Amplify: \(error)")
           }
    }

    func signUp(username: String, password: String, email: String) async throws -> Bool {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)

        do {
            let result = try await Amplify.Auth.signUp(username: username, password: password, options: options)
            return result.isSignUpComplete
        } catch let error {
            throw AuthError.error(error as NSError)
        }
    }

    func confirmSignUp(username: String, confirmationCode: String) async throws -> Bool {
        do {
            let result = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
            if result.isSignUpComplete {
                return true
            } else {
                throw AuthError.signinIncomplete
            }
        } catch let error {
            throw AuthError.error(error as NSError)
        }
    }

    func signIn(username: String, password: String) async throws -> User {
        do {
            let _ = await Amplify.Auth.signOut()

            let result = try await Amplify.Auth.signIn(username: username, password: password)
            if result.isSignedIn {
                var claims = [String: Any]()
                let attrs = try await Amplify.Auth.fetchUserAttributes()
                for attr in attrs {
                    claims["\(attr.key)"] = attr.value
                }
                return User(username: username, claims: claims)
            } else {
                throw AuthError.signinIncomplete
            }
        } catch let error {
            throw AuthError.error(error as NSError)
        }
    }
}
