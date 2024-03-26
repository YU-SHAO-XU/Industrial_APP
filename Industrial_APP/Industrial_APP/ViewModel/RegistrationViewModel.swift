//
//  RegistrationViewModel.swift
//  Industrial_APP
//
//  Created by User on 2024/1/3.
//

import Foundation

class RegistrationViewModel: ObservableObject{
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    
    func createUser()async throws{
       try await  AuthService.shared.createUser(email: email, password: password, username: username)
    }
}
