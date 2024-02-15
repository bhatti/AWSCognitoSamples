//
//  SignInView.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var cognitoManager: CognitoManager
    @Binding var isAuthenticated: Bool
    @Binding var user: User?

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Sign In") {
                Task {
                    do {
                        self.user = try await cognitoManager.signIn(username: username, password: password)
                        self.isAuthenticated = true
                    } catch (let err as AuthError) {
                        print("error --- \(err)")
                        self.errorMessage = err.toString()
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            if (errorMessage != "") {
                Label(
                    title: { Text(errorMessage).foregroundColor(.red) },
                    icon: { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red) }
                )
            }
        }.padding()
    }
}
