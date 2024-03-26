//
//  Profile.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import Foundation

import SwiftUI

struct UserProfile: Identifiable {
    let id = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var bio: String
}

class ProfileManager: ObservableObject {
    @Published var userProfile: UserProfile

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
}


struct rofileView: View {
    @ObservedObject var profileManager: ProfileManager

    var body: some View {
        Form {
            Section(header: Text("個人檔案")) {
                TextField("名字", text: $profileManager.userProfile.firstName)
                TextField("姓氏", text: $profileManager.userProfile.lastName)
                TextField("Email", text: $profileManager.userProfile.email)
            }

            Section(header: Text("個人簡介")) {
                TextEditor(text: $profileManager.userProfile.bio)
                    .frame(height: 100)
            }
        }
        .navigationTitle("個人檔案")
        .navigationBarTitleDisplayMode(.inline)
    }
}





    
