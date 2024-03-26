//
//  IEViewModel.swift
//  Industrial_APP
//
//  Created by User on 2024/1/4.
//

import Foundation

class IEViewModel: ObservableObject {
    @Published var productionOrder: [Process] = []
    func addProcess(productName: String, quantity: String, machine: String, progress: String) {
        let newproductionOrder = Process(id: UUID(), productName: productName, quantity: quantity, machine: machine, progress: progress)
            productionOrder.append(newproductionOrder)
    }
}

