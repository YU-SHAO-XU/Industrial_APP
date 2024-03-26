
//搜尋功能
//新增不得空白
//list排序?
//新增跟刪除有很多bug!!!!!3/11 完成
//新增排序3

 import SwiftUI
 import Foundation
 import FirebaseFirestore

 struct Person: Identifiable, Codable {
     var id: UUID // 使用 UUID 作為唯一 ID
     var name: String
     var date: String
     var product: String
     var quantity: String
     var delivery: String
 }


 struct Order: View {
     
     @State private var searchText = ""
     @State private var people: [Person] = [] //類型 [Person]，初始值＝[]
     @State private var isAddOrderViewPresented: Bool = false
     @State private var showAlert = false
     @State private var deleteIndexSet: IndexSet?
     
     var filteredOrder: [Person] {
         if searchText.isEmpty {
             return people
         } else {
             return people.filter { user in
                 user.name.lowercased().contains(searchText.lowercased()) ||
                 user.date.lowercased().contains(searchText.lowercased()) ||
                 user.product.lowercased().contains(searchText.lowercased()) ||
                 user.quantity.lowercased().contains(searchText.lowercased()) ||
                 user.delivery.lowercased().contains(searchText.lowercased())
             }
         }
     }
     
     var body: some View {
         NavigationView {
             VStack {
                 List {
                     HStack {
                         Text("Cliente")
                             .frame(maxWidth: .infinity, alignment: .center)
                         Text("Fecha")
                             .frame(maxWidth: .infinity, alignment: .center)
                         Text("Producto")
                             .frame(maxWidth: .infinity, alignment: .center)
                         Text("Cantidad")
                             .frame(maxWidth: .infinity, alignment: .center)
                         Text("Entregar")
                             .frame(maxWidth: .infinity, alignment: .center)
                     }
                     
                     ForEach(filteredOrder) { user in
                         HStack {
                             Text(user.name)
                                 .frame(maxWidth: .infinity, alignment: .center)
                             Text(user.date)
                                 .frame(maxWidth: .infinity, alignment: .center)
                             Text(user.product)
                                 .frame(maxWidth: .infinity, alignment: .center)
                             Text(user.quantity)
                                 .frame(maxWidth: .infinity, alignment: .center)
                             Text(user.delivery)
                                 .frame(maxWidth: .infinity, alignment: .center)
                         }
                     }
                     
                     .onDelete(perform: { indexSet in
                         deleteIndexSet = indexSet
                         showAlert.toggle()
                     })
                 }
                 .searchable(text: $searchText, prompt: "Buscar...")
                 Spacer()
             }
             .navigationBarTitle("Orden", displayMode: .inline)
             .navigationBarItems(trailing: Button(action: {
                 isAddOrderViewPresented.toggle()
             }) {
                 Image(systemName: "plus")
             }
                 .sheet(isPresented: $isAddOrderViewPresented) {
                     AddOrderView(people: $people, isAddOrderViewPresented: $isAddOrderViewPresented)
                     
                 }
                                 
             )
             .alert(isPresented: $showAlert) {
                 Alert(
                     title: Text("¡Advertencia!"),
                     message: Text("¿Estás seguro de eliminar este Orden?"),
                     primaryButton: .destructive(Text("Eliminar")) {
                         // 在這裡處理刪除動作
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
         let idsToDelete = indexSet.compactMap { people[$0].id.uuidString }
         
         // 从本地数据中删除行
         people.remove(atOffsets: indexSet)
         
         // 删除对应的 Firebase 文档
         let db = Firestore.firestore()
         let ordersCollection = db.collection("orders")
         
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

     private func fetchFromFirestore() {
         let db = Firestore.firestore()
         let collectionRef = db.collection("orders")
         
         collectionRef.getDocuments { snapshot, error in
             if let error = error {
                 print("Error getting documents: \(error)")
                 return
             }
             
             guard let documents = snapshot?.documents else {
                 print("No documents")
                 return
             }
             
             people = documents.compactMap { document in
                 guard var person = try? document.data(as: Person.self) else { return nil }
                 person.id = UUID(uuidString: document.documentID) ?? UUID() // 使用 Firestore 文檔的 ID 作為 Person 的 ID
                 return person
             }

         }
     }

 }

 struct AddOrderView: View {
     @Binding var people: [Person]
     @State private var newOrder = Person(id: UUID(), name: "", date: "", product: "", quantity: "", delivery: "") // 使用 UUID() 創建唯一 ID
     @Binding var isAddOrderViewPresented: Bool
     @Environment(\.presentationMode) var presentationMode
     
     var body: some View {
         NavigationView {
             VStack {
                 Form {
                     Section{
                         TextField("Cliente", text: $newOrder.name)
                         TextField("Fecha", text: $newOrder.date)
                         TextField("Producto", text: $newOrder.product)
                         TextField("Cantidad", text: $newOrder.quantity)
                         TextField("Entregar", text: $newOrder.delivery)
                     }
                 }
                 .navigationTitle("Agregar Orden")
                 .navigationBarItems(trailing: Button("Ahorrar", action: saveOrder))
                 .navigationBarItems(leading: Button("Cancelar") {
                     presentationMode.wrappedValue.dismiss()
                 }
                 .foregroundColor(.red))
             }
         }
     }
     
     private func saveOrder() {
         // 將訂單數據保存到 Firebase
         let db = Firestore.firestore()
         let ordersCollection = db.collection("orders")
         
         do {
             let documentReference = try ordersCollection.addDocument(from: newOrder)
             let documentID = documentReference.documentID
             print("Document added with ID: \(documentID)")
             
             // 保存成功后，將新訂單添加到 local 端
  // 將 Firebase 文件 ID 賦值給 Person 的 id 屬性
             people.append(newOrder)
             isAddOrderViewPresented = false
         } catch {
             print("Error adding document: \(error)")
             // 報錯
         }
     }
 }

 struct Order_Previews: PreviewProvider {
     static var previews: some View {
         Order()
     }
 }



