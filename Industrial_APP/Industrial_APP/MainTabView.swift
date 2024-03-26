//
//  MainTabView.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.

//Diary 有bug

import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all) // 設定背景色
            TabView {
                IE().tabItem { Image(systemName: "ellipsis.message.fill") }
                Order().tabItem { Image(systemName: "list.bullet.clipboard") }
                MachineControl().tabItem { Image(systemName: "wrench.adjustable") }
                Sop().tabItem { Image(systemName: "doc") }
            }
            .accentColor(.black)
        }
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

