//
//  MainTabView.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all) // Set background color
            TabView {
                Order().tabItem {
                    Image(systemName: "storefront.fill")
                    Text("Order")
                }
                InventoryView().tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Inventory")
                }
                IE().tabItem {
                    Image(systemName: "ellipsis.message.fill")
                    Text("IE")
                }
                MachineControl().tabItem {
                    Image(systemName: "wrench.adjustable")
                    Text("Machine Control")
                }
                Cost().tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Cost")
                }
            }
            .accentColor(.black)
        }
    }
}

// Preview for SwiftUI canvas
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
