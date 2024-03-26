//
//  ContentView.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    var body: some View {
        Group{
            if viewModel.userSession == nil {
                Login()
                    .environmentObject(registrationViewModel)
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    ContentView()
}
