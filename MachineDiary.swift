import SwiftUI
import FirebaseFirestore

struct RepairRecord: Identifiable {
    let id = UUID()
    let machineID: String
    let timestamp: Date
    let repairPerson: String
    let caption: String
}

struct ReasonRecord: View {
    @State private var repairPerson = ""
    @State private var caption = ""
    @State private var repairRecords: [RepairRecord] = []
    @Environment(\.dismiss) var dismiss
    let machineID: String
    let reasonID: String

    var body: some View {
        VStack {
            VStack {
                TextField("Persona de mantenimiento", text: $repairPerson)
                TextField("Registro de máquina...", text: $caption)
            }

            Spacer()

            List {
                ForEach(repairRecords) { record in
                    VStack(alignment: .leading) {
                        Text("Persona de mantenimiento: \(record.repairPerson)")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text("Registro: \(record.caption)")
                        Text("Tiempo: \(formattedTimestamp(for: record.timestamp))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteRecord)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    saveRecord()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
        .onAppear {
            fetchRecords()
        }
    }

    func saveRecord() {
        if !repairPerson.isEmpty && !caption.isEmpty {
            let newRecord = RepairRecord(machineID: machineID, timestamp: Date(), repairPerson: repairPerson, caption: caption)

            let db = Firestore.firestore()
            let collectionRef = db.collection("Machine_Diary")

            collectionRef.addDocument(data: [
                "id": newRecord.id.uuidString,
                "machineID": machineID,
                "reasonID": reasonID,
                "timestamp": newRecord.timestamp,
                "repairPerson": newRecord.repairPerson,
                "caption": newRecord.caption
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully!")
                    repairRecords.append(newRecord)
                    repairPerson = ""
                    caption = ""
                }
            }
        }
    }

    private func deleteRecord(at indexSet: IndexSet) {
        // 获取要删除的文档的 ID
        let idsToDelete = indexSet.compactMap { repairRecords[$0].id.uuidString }
        repairRecords.remove(atOffsets: indexSet)
        
        // 删除对应的 Firebase 文档
        let db = Firestore.firestore()
        let ordersCollection = db.collection("Machine_Diary")
        
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

    func fetchRecords() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Machine_Diary")

        collectionRef.whereField("machineID", isEqualTo: machineID)
            .whereField("reasonID", isEqualTo: reasonID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }

                var records: [RepairRecord] = []
                for document in documents {
                    let data = document.data()
                    if let timestamp = data["timestamp"] as? Timestamp,
                       let repairPerson = data["repairPerson"] as? String,
                       let caption = data["caption"] as? String {
                        let record = RepairRecord(machineID: machineID, timestamp: timestamp.dateValue(), repairPerson: repairPerson, caption: caption)
                        records.append(record)
                    }
                }

                repairRecords = records
            }
    }

    func formattedTimestamp(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
}


