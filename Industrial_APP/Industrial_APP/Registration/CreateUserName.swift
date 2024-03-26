//
//  CreateUserName.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct CreateUserName: View {
    
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    var body: some View {
        VStack{
            Text("Create user name")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("You will use this eamil to sign up your account")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal,24)
            
            TextField("Email",text: $viewModel.username)
                .autocorrectionDisabled()
                .modifier(TextModifier())
            
            NavigationLink{
                Password()
                    .navigationBarBackButtonHidden(true)
            }label: {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360 , height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .padding(.vertical)
            Spacer()
        }
        .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .onTapGesture {
                                dismiss()
                            }
                    }
        }
        
    }
}

#Preview {
    CreateUserName()
}


