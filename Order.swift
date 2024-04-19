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
                    HeaderRow()
                    
                    ForEach($orders) { $order in
                        HStack {
                            TextField("Cliente", text: $order.name, onCommit: {
                                self.saveOrder(order)
                            })
                            TextField("Fecha", text: $order.date, onCommit: {
                                self.saveOrder(order)
                            })
                            TextField("Producto", text: $order.product, onCommit: {
                                self.saveOrder(order)
                            })
                            TextField("Cantidad", text: $order.quantity, onCommit: {
                                self.saveOrder(order)
                            })
                            TextField("Entregar", text: $order.delivery, onCommit: {
                                self.saveOrder(order)
                            })
                            
                            Button(action: {
                                self.deleteOrder = order
                                self.showAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                Button(action: {
                    self.addOrder()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add")
                    }
                }
            }
            .navigationBarTitle("Orden", displayMode: .inline)
            .onAppear {
                self.fetchOrders()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Confirm Delete"), message: Text("Are you sure you want to delete this row?"), primaryButton: .destructive(Text("Delete")) {
                    if let orderToDelete = self.deleteOrder {
                        self.deleteOrder(orderToDelete)
                    }
                }, secondaryButton: .cancel())
            }
        }
    }
    
    private func HeaderRow() -> some View {
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
            self.orders = documents.compactMap { document in
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
                if let index = self.orders.firstIndex(where: { $0.id == order.id }) {
                    self.orders.remove(at: index)
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

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
