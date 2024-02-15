//
//  ContentView.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import SwiftUI

class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct ContentView: View {
    @EnvironmentObject var cognitoManager: CognitoManager
    @StateObject var tabSelection = TabSelection()
    
    @State private var isAuthenticated = false
    @State private var user: User?
    
    var body: some View {
        if isAuthenticated {
            UserView(user: user!)
        } else {
            TabView(selection: $tabSelection.selectedTab) {
                SignUpView().environmentObject(cognitoManager)
                    .tabItem {
                        Label("Sign Up", systemImage: "person.badge.plus")
                    }
                    .tag(0)
                ConfirmationView().environmentObject(cognitoManager)
                    .tabItem {
                        Label("Confirmation", systemImage: "person.fill.checkmark")
                    }
                    .tag(1)
                SignInView(isAuthenticated: $isAuthenticated, user: $user).environmentObject(cognitoManager)
                    .tabItem {
                        Label("Sign In", systemImage: "person.fill")
                    }
                    .tag(2)
            }.environmentObject(tabSelection)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
