//
//  CompleteSignUp.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct CompleteSignUp: View {
    
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    var body: some View {
        VStack{
            Spacer()
            
            Text("Welcome Bumbu System")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Click below to complete registration")
                .font(.footnote)
                .padding()
            
            Button{
                Task{try await viewModel.createUser()}
            } label: {
                Text("Complete Sign Up")
            }
           /*NavigationLink{
                login()
                    .navigationBarBackButtonHidden(true)
            }label: {
                Text("Complete Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360 , height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }*/
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
    CompleteSignUp()
}
