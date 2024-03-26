//
//  login.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct Login: View {
    
    @StateObject var viewModel = LoginViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    var body: some View {
        NavigationView{
            VStack{
                Image("icdf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 440, height: 200)
                
                TextField("Enter your email", text: $viewModel.email)
                    .autocorrectionDisabled()
                    .modifier(TextModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(TextModifier())
                
                Button{
                    print("Show forgot password")
                } label: {
                    Text("Forgot password ?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing,28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button{
                    Task{ try await viewModel.signin() }
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
                
                NavigationLink{
                    Registration()
                       // .environmentObject(registrationViewModel)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing:3){
                        Text("Don't have a account ?")
                        
                        Text ("Sign up")
                            .fontWeight(.semibold)
                        
                    }
                    .foregroundColor(.blue)
                }
                .font(.footnote)
            }
            .padding(.vertical,16)
        }
    }
}

#Preview {
        Login()
}
