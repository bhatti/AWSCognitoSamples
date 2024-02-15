//
//  MyIOSAppApp.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/7/24.
//

import SwiftUI

@main
struct MyIOSAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CognitoManager())
        }
    }
}
