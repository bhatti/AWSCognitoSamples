//
//  UserView.swift
//  MyIOSApp
//
//  Created by Bhatti, Shahzad on 2/12/24.
//

import SwiftUI

struct UserView: View {
    @State private var user: User

    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        Section(user.username) {
            List(user.claims.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text(String(describing: value))
                }
            }
        }
    }
}
