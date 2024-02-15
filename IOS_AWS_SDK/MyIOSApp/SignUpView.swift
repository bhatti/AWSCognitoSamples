//
//  SignUpView.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var cognitoManager: CognitoManager
    @EnvironmentObject var tabSelection: TabSelection

    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Sign Up") {
                cognitoManager.signUp(username: username, password: password, email: email) { result in
                    switch result {
                    case .success(_):
                        tabSelection.selectedTab = 1
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
