//
//  Inventory.swift
//  Industrial_APP
//
//  Created by User on 2024/4/11.
//

import SwiftUI
import FirebaseFirestore

struct RowData: Identifiable, Codable {
    var id: String
    var product: String
    var product_description: String
    var existing: String
    var nonexistence: String
}

struct InventoryView: View {
    @State private var rows = [RowData]()
    @State private var showAlert = false
    @State private var deleteRow: RowData?
    private let collectionReference = Firestore.firestore().collection("rows")

    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack{
                        Text("Producto")
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .padding(2)
                            .frame(width: 80.0, height: 25.0)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                        
                        Text("Descripcion")
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .padding(2)
                            .frame(width: 80.0, height: 25.0)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Text("Existente")
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .padding(2)
                            .frame(width: 80.0, height: 25.0)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Text("Inexistencia ")
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                            .padding(2)
                            .frame(width: 80.0, height: 25.0)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    ForEach($rows) { $row in
                        HStack {
                            TextField("Producto", text: $row.product, onCommit: {
                                self.saveRow(row)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Descripcion del producto", text: $row.product_description, onCommit: {
                                self.saveRow(row)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Existing", text: $row.existing, onCommit: {
                                self.saveRow(row)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Nonexistence", text: $row.nonexistence, onCommit: {
                                self.saveRow(row)
                            })
                            .frame(maxWidth: .infinity, alignment: .leading) // Align the content to the leading edge
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            
                            Button(action: {
                                self.deleteRow = row
                                self.showAlert = true
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                
                Spacer() // Push "Add" button to the bottom
                
                Button(action: {
                    self.addRow()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add")
                    }
                }

            }
            .navigationBarTitle("Inventario", displayMode: .inline)
            .onAppear {
                self.fetchRows()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Confirm Delete"), message: Text("Are you sure you want to delete this row?"), primaryButton: .destructive(Text("Delete")) {
                    if let rowToDelete = self.deleteRow {
                        self.deleteRow(rowToDelete)
                    }
                }, secondaryButton: .cancel())
            }
        }
    }

    private func fetchRows() {
        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.rows = documents.compactMap { document in
                do {
                    let rowData = try document.data(as: RowData.self)
                    return rowData
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
        }
    }
    
    private func saveRow(_ row: RowData) {
        do {
            try collectionReference.document(row.id).setData(from: row)
        } catch {
            print("Error saving document: \(error)")
        }
    }
    
    private func deleteRow(_ row: RowData) {
        collectionReference.document(row.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                // If deletion from Firebase is successful, remove the corresponding row from the UI
                if let index = self.rows.firstIndex(where: { $0.id == row.id }) {
                    self.rows.remove(at: index)
                }
            }
        }
    }

    private func addRow() {
        let newRow = RowData(id: UUID().uuidString, product: "", product_description: "", existing: "", nonexistence: "")
        rows.insert(newRow, at: 0)
        saveRow(newRow)
    }
}
 
struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
