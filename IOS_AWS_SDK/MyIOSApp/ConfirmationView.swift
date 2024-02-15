//
//  ConfirmationView.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var cognitoManager: CognitoManager
    @EnvironmentObject var tabSelection: TabSelection

    @State private var confirmationCode = ""
    @State private var username = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Confirmation Code", text: $confirmationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Confirm Account") {
                cognitoManager.confirmSignUp(username: username, confirmationCode: confirmationCode) { result in
                    switch result {
                    case .success(_):
                        tabSelection.selectedTab = 2
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


