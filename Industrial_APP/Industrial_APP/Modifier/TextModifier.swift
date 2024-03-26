//
//  TextModifier.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI

struct TextModifier: ViewModifier {
    func body (content : Content) -> some View{
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal,24)
    }
}
