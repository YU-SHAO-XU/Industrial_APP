//
//  ContentView.swift
//  Industrial_APP
//
//  Created by User on 2023/3/11.
//

import SwiftUI
import FirebaseFirestore

struct OrderData: Identifiable, Codable {
    var id: String
    var name: String
    var date: String
    var product: String
    var quantity: String
    var delivery: String
}

struct Order: View {
    @State private var orders: [OrderData] = []
    @State private var showAlert = false
    @State private var deleteOrder: OrderData?
    private let collectionReference = Firestore.firestore().collection("orders")
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    headerRow
                    
                    ForEach($orders) { $order in
                        HStack {
                            OrderTextField(placeholder: "Cliente", text: $order.name, onCommit: { saveOrder(order) })
                            OrderTextField(placeholder: "Fecha", text: $order.date, onCommit: { saveOrder(order) })
                            OrderTextField(placeholder: "Producto", text: $order.product, onCommit: { saveOrder(order) })
                            OrderTextField(placeholder: "Cantidad", text: $order.quantity, onCommit: { saveOrder(order) })
                            OrderTextField(placeholder: "Entregar", text: $order.delivery, onCommit: { saveOrder(order) })
                            
                            Button(action: {
                                deleteOrder = order
                                showAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Orden", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: addOrder) {
                Image(systemName: "plus")
            })
            .onAppear(perform: fetchOrders)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this row?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let orderToDelete = deleteOrder {
                            deleteOrder(orderToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private var headerRow: some View {
        HStack {
            Text("Cliente").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Fecha").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Producto").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Cantidad").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Entregar").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func fetchOrders() {
        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            orders = documents.compactMap { document in
                do {
                    let orderData = try document.data(as: OrderData.self)
                    return orderData
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
        }
    }

    private func saveOrder(_ order: OrderData) {
        do {
            try collectionReference.document(order.id).setData(from: order)
        } catch {
            print("Error saving document: \(error)")
        }
    }
    
    private func deleteOrder(_ order: OrderData) {
        collectionReference.document(order.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                if let index = orders.firstIndex(where: { $0.id == order.id }) {
                    orders.remove(at: index)
                }
            }
        }
    }
    
    private func addOrder() {
        let newOrder = OrderData(id: UUID().uuidString, name: "", date: "", product: "", quantity: "", delivery: "")
        orders.insert(newOrder, at: 0)
        saveOrder(newOrder)
    }
}

struct OrderTextField: View {
    let placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        TextField(placeholder, text: $text, onCommit: onCommit)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 4)
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
