//
//  LoginViewModel.swift
//  Industrial_APP
//
//  Created by User on 2024/1/3.
//

import Foundation

class LoginViewModel : ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    func signin() async throws {
       try await  AuthService.shared.login(withEmail: email, password: password)
    }
}
