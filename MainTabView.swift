//
//  MainTabView.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.

import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all) // 設定背景色
            TabView {
                Order().tabItem { Image(systemName: "storefront.fill") }
                InventoryView().tabItem { Image(systemName: "list.bullet.clipboard") }
                IE().tabItem { Image(systemName: "ellipsis.message.fill") }
                MachineControl().tabItem { Image(systemName: "wrench.adjustable") }
                Cost().tabItem { Image(systemName: "dollarsign.circle") }
               // Sop().tabItem { Image(systemName: "doc") }
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

