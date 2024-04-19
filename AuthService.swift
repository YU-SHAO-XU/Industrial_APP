//
//  AuthService.swift
//  Industrial_APP
//
//  Created by User on 2024/1/3.
//

import Foundation
import Firebase



class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    init(){
        self.userSession = Auth.auth().currentUser
    }
    @MainActor
    func login(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to login user with error \(error.localizedDescription)")
        }
        
    }
    
    
    func signout(){
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
