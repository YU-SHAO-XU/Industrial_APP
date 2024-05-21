//
//  login.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI
import Firebase

struct Login: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoggedIn = false 
    
    var body: some View {
        NavigationView {
            VStack {
                Image("icdf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 440, height: 200)
                
                TextField("Enter your email", text: $viewModel.email)
                    .autocorrectionDisabled()
                    .modifier(TextModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(TextModifier())
                
                Button {
                    Task {
                        do {
                            try await viewModel.signin()
                            isLoggedIn = true 
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360 , height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
                .padding(.vertical)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isLoggedIn, content: {
            MainTabView()
        })
        .navigationBarBackButtonHidden(true)
    }
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signin() async throws {
        guard !email.isEmpty else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email is required"])
        }
        
        guard !password.isEmpty else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password is required"])
        }
        
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
