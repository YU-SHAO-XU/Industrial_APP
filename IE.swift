//
//  ContentView.swift
//  Industrial_APP
//
//  Created by User on 2023/2/21.
//

import SwiftUI
import FirebaseFirestore

struct ProcessData: Identifiable, Codable {
    var id: String
    var name: String
    var quantity: String
    var machine: String
    var progress: String
}

struct IE: View {
    @State private var processes: [ProcessData] = []
    @State private var showAlert = false
    @State private var deleteProcess: ProcessData?
    private let collectionReference = Firestore.firestore().collection("processes")
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HeaderRow()
                    
                    ForEach($processes) { $process in
                        HStack {
                            TextField("Producto", text: $process.name, onCommit: {
                                saveProcess(process)
                            })
                            TextField("Cantidad", text: $process.quantity, onCommit: {
                                saveProcess(process)
                            })
                            TextField("Máquina", text: $process.machine, onCommit: {
                                saveProcess(process)
                            })
                            TextField("Progreso", text: $process.progress, onCommit: {
                                saveProcess(process)
                            })
                            
                            Button(action: {
                                deleteProcess = process
                                showAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Proceso", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                addProcess()
            }) {
                Image(systemName: "plus")
            })
            .onAppear {
                fetchProcesses()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this row?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let processToDelete = deleteProcess {
                            deleteProcess(processToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func HeaderRow() -> some View {
        HStack {
            Text("Producto").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Cantidad").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Máquina").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
            Text("Progreso").font(.footnote).frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func fetchProcesses() {
        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            processes = documents.compactMap { document in
                do {
                    let processData = try document.data(as: ProcessData.self)
                    return processData
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
        }
    }

    private func saveProcess(_ process: ProcessData) {
        do {
            try collectionReference.document(process.id).setData(from: process)
        } catch {
            print("Error saving document: \(error)")
        }
    }
    
    private func deleteProcess(_ process: ProcessData) {
        collectionReference.document(process.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                if let index = processes.firstIndex(where: { $0.id == process.id }) {
                    processes.remove(at: index)
                }
            }
        }
    }
    
    private func addProcess() {
        let newProcess = ProcessData(id: UUID().uuidString, name: "", quantity: "", machine: "", progress: "")
        processes.insert(newProcess, at: 0)
        saveProcess(newProcess)
    }
}

struct IE_Previews: PreviewProvider {
    static var previews: some View {
        IE()
    }
}
