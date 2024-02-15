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
                cognitoManager.signIn(username: username, password: password) { result in
                    switch result {
                    case .success(let user):
                        self.user = user
                        self.isAuthenticated = true
                    case .failure(let error):
                        self.errorMessage = error.toString()
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
