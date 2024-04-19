import SwiftUI
import FirebaseFirestore

struct Process: Identifiable, Codable {
    var id: UUID // 使用 UUID 作為唯一 ID
    var productName: String
    var quantity: String
    var machine: String
    var progress: String
}

struct IE: View {
    @State private var searchText = ""
    @State private var productionOrder: [Process] = []
    @State private var isSheetPresented = false
    @State private var showAlert = false
    @State private var deleteIndexSet: IndexSet?
    
    var filteredProductionOrder: [Process] {
        if searchText.isEmpty {
            return productionOrder
        } else {
            return productionOrder.filter { process in
                process.productName.lowercased().contains(searchText.lowercased()) ||
                process.quantity.lowercased().contains(searchText.lowercased()) ||
                process.machine.lowercased().contains(searchText.lowercased()) ||
                process.progress.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredProductionOrder) { process in
                        VStack() {
                           /* Text("ID: \(process.id)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)*/
                            Text("Producto: \(process.productName)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                            Text("Cantidad: \(process.quantity)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                            Text("Máquina: \(process.machine)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                            Text("Progreso: \(process.progress)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        deleteIndexSet = indexSet
                        showAlert.toggle()
                    }) // Enable row deletion

                }
                .searchable(text: $searchText, prompt: "Buscar...")
                
                Spacer()
            }
            .navigationBarTitle("Proceso", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isSheetPresented.toggle()
            }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $isSheetPresented) {
                AddProcessView(productionOrder: $productionOrder, isSheetPresented: $isSheetPresented)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("¡Advertencia!"),
                    message: Text("¿Estás seguro de eliminar este proceso?"),
                    primaryButton: .destructive(Text("Eliminar")) {
                        // Perform deletion action here
                        if let indexSet = deleteIndexSet {
                            deleteRow(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancelar"))
                )
            }
        }
        .onAppear {
            fetchFromFirestore()
        }
    }
    
    // Function to delete a row
    private func deleteRow(at indexSet: IndexSet) {
        // 获取要删除的文档的 ID
        let idsToDelete = indexSet.compactMap { productionOrder[$0].id.uuidString }
        productionOrder.remove(atOffsets: indexSet)
        
        // 删除对应的 Firebase 文档
        let db = Firestore.firestore()
        let ordersCollection = db.collection("process")
        
        idsToDelete.forEach { id in
            ordersCollection.whereField("id", isEqualTo: id).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            print("Document successfully removed from Firestore")
                        }
                    }
                }
            }
        }
    }
    // Function to fetch data from Firestore
    private func fetchFromFirestore() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("process")
        
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            productionOrder = documents.compactMap { document in
                var process = try? document.data(as: Process.self)
                process?.id = UUID(uuidString: document.documentID) ?? UUID() // 將 Firestore 文檔 ID 賦值給 process 的 id 屬性
                return process
            }
        }
    }
}

struct AddProcessView: View {
    @Binding var productionOrder: [Process]
    @State private var newProcess = Process(id: UUID(), productName: "", quantity: "", machine: "", progress: "")
    @Binding var isSheetPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Nombre del producto", text: $newProcess.productName)
                        TextField("Cantidad", text: $newProcess.quantity)
                        TextField("Máquina", text: $newProcess.machine)
                        TextField("Progreso", text: $newProcess.progress)
                    }
                }
                .navigationBarTitle("Agregar proceso")
                .navigationBarItems(
                    leading: Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.red),
                    trailing: Button("Ahorrar", action: saveOrder)
                )
            }
        }
    }

    
    private func saveOrder() {
        let db = Firestore.firestore()
        let ordersCollection = db.collection("process")
        
        do {
            let documentReference = try ordersCollection.addDocument(from: newProcess)
            let documentID = documentReference.documentID
            print("Document added with ID: \(documentReference.documentID)")
            
            // After successful save, add the new order to local data
            productionOrder.append(newProcess)
            isSheetPresented = false
        } catch {
            print("Error adding document: \(error)")
        }
    }
}

 struct IE_Previews: PreviewProvider {
     static var previews: some View {
         IE()
     }
 }
