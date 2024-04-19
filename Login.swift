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
    @State private var isLoggedIn = false // 新增一個狀態來表示是否已登入
    
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
                            isLoggedIn = true // 登入成功後設置為 true
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            // 登入失敗，顯示相應的錯誤消息
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
        .navigationBarBackButtonHidden(true) // 隱藏返回按鈕
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
        
        // 驗證帳號密碼
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        // 如果驗證成功，result.user 將包含用戶信息
    }
}

// 修改預覽
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
