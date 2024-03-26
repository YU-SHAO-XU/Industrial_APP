//
//  OrderViewModel.swift
//  Industrial_APP
//
//  Created by User on 2024/1/4.
//

import Foundation

class OrderViewModel : ObservableObject{
    @Published var people:[Person] = []
    func addOrder ( name: String, date: String, product: String, quantity: String, delivery: String)  {
        let newOrder = Person(id : UUID(), name: name, date: date, product: product, quantity: quantity, delivery: delivery)
            people.append(newOrder)
    }
}

