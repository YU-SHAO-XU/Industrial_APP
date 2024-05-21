//
//  Diary.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import Foundation
import SwiftUI
import Charts
import FirebaseFirestore

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let machineStatusKey = "MachineStatus"
    
    func saveMachineStatus(_ machineID: String, isRunning: Bool) {
        UserDefaults.standard.set(isRunning, forKey: "\(machineStatusKey)_\(machineID)")
    }
    
    func getMachineStatus(_ machineID: String) -> Bool {
        return UserDefaults.standard.bool(forKey: "\(machineStatusKey)_\(machineID)")
    }
}

struct Machine: Identifiable {
    var id = UUID()
    var machineID: String
    var name: String
    var description: String
    var isRunning: Bool
    
    init(machineID: String, name: String, description: String, isRunning: Bool) {
        self.machineID = machineID
        self.name = name
        self.description = description
        self.isRunning = isRunning
    }
}

struct MachineControl: View {
    @State private var machines: [Machine] = [
        Machine(machineID: "1", name: "竹管定長機 \n CORTADORA BAMBÚ", description: "Description 1", isRunning: UserDefaultsManager.shared.getMachineStatus("1")),
        Machine(machineID: "2", name: "竹條取片機 \n CORTADORA PARA FAJAS", description: "Description 2", isRunning: UserDefaultsManager.shared.getMachineStatus("2")),
        Machine(machineID: "3", name: "連環式竹節修平機-1 \n CEPILLADORAS 2 CARAS-1", description: "Description 3", isRunning: UserDefaultsManager.shared.getMachineStatus("3")),
        Machine(machineID: "4", name: "連環式竹節修平機-2 \n CEPILLADORAS 2 CARAS-2", description: "Description 4", isRunning: UserDefaultsManager.shared.getMachineStatus("4")),
        Machine(machineID: "5", name: "竹條修平機-1 \n CEPILLADORA 2 CARAS-1", description: "Description 5", isRunning: UserDefaultsManager.shared.getMachineStatus("5")),
        Machine(machineID: "6", name: "竹條修平機-2 \n CEPILLADORA 2 CARAS-2", description: "Description 6", isRunning: UserDefaultsManager.shared.getMachineStatus("6")),
        Machine(machineID: "7", name: "熱處理機 \n TINA", description: "Description 7", isRunning: UserDefaultsManager.shared.getMachineStatus("7")),
        Machine(machineID: "8", name: "碳化爐 \n CARBONIZADORA", description: "Description 8", isRunning: UserDefaultsManager.shared.getMachineStatus("8")),
        Machine(machineID: "9", name: "四面鉋 \n CEPILLADORA 4 CARAS", description: "Description 9", isRunning: UserDefaultsManager.shared.getMachineStatus("9")),
        Machine(machineID: "10", name: "佈膠 \n ENCOLADORA", description: "Description 10", isRunning: UserDefaultsManager.shared.getMachineStatus("10")),
        Machine(machineID: "11", name: "多軸開槽機 \n MOLDURADORA", description: "Description 11", isRunning: UserDefaultsManager.shared.getMachineStatus("11")),
        Machine(machineID: "12", name: "熱壓機 \n PRENSA", description: "Description 12", isRunning: UserDefaultsManager.shared.getMachineStatus("12")),
        Machine(machineID: "13", name: "砂磨機 \n LIJADORA", description: "Description 13", isRunning: UserDefaultsManager.shared.getMachineStatus("13")),
        Machine(machineID: "14", name: "桌上型圓鋸機 \n SIERRAS RADIALES", description: "Description 14", isRunning: UserDefaultsManager.shared.getMachineStatus("14")),
        Machine(machineID: "15", name: "單面鋸直機 \n SIERRA BANDEADORA", description: "Description 15", isRunning: UserDefaultsManager.shared.getMachineStatus("15")),
        Machine(machineID: "16", name: "雷射雕刻機 \n LASER", description: "Description 16", isRunning: UserDefaultsManager.shared.getMachineStatus("16")),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                    ForEach(machines) { machine in
                        NavigationLink(destination: MachineDetail(
                            isRunning: $machines[machineIndex(machine)].isRunning,
                            machine: $machines[machineIndex(machine)],
                            machineID: machine.machineID
                        )) {
                            MachineButton(machine: machine)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Máquina", displayMode: .inline)
        }
    }
    
    func machineIndex(_ machine: Machine) -> Int {
        guard let index = machines.firstIndex(where: { $0.id == machine.id }) else {
            return 0
        }
        return index
    }
}

struct MachineButton: View {
    var machine: Machine

    var body: some View {
        Text(machine.name)
            .font(.caption2)
            .lineLimit(2)
            .foregroundColor(.black)
            .truncationMode(.tail)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(machine.isRunning ? Color.green : Color.red, lineWidth: 5)
            )
    }
}

struct MachineDetail: View {
    struct ReasonItem: Identifiable {
        var id = UUID()
        var reason: String
        var machineID: String
        var reasonID: String
        var count: Int
    }
    
    @Binding var isRunning: Bool
    @Binding var machine: Machine
    @State private var reasons: [ReasonItem] = [
        ReasonItem(reason: "Operación incorrecta", machineID: "", reasonID: "1", count: 0),
        ReasonItem(reason: "Equipo desgastado", machineID: "", reasonID: "2", count: 0),
        ReasonItem(reason: "Falta de material", machineID: "", reasonID: "3", count: 0),
        ReasonItem(reason: "Otros", machineID: "", reasonID: "4", count: 0),
    ]
    
    @Environment(\.dismiss) var dismiss
    let machineID: String
    
    var body: some View {
        VStack {
            Chart(reasons) { reason in
                SectorMark(
                    angle: .value(Text(verbatim: reason.reason), reason.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value(
                    Text(verbatim: reason.reason),
                    String(reason.reason)
                ))
            }
            .frame(width: 350, height: 300)
            
            VStack {
                List {
                    HStack {
                        Text("Razón")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .listRowBackground(Color.gray)
                    
                    ForEach(reasons, id: \.reason) { item in
                        NavigationLink(destination: ReasonRecord(machineID: machineID, reasonID: item.reasonID)) {
                            Text(item.reason)
                                .font(.callout)
                                .lineLimit(2)
                                .foregroundColor(.black)
                                .truncationMode(.tail)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            Toggle("Estado", isOn: $isRunning)
                .padding()
        }
        .navigationTitle("Analisis fallido")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .onDisappear {
            UserDefaultsManager.shared.saveMachineStatus(machine.machineID, isRunning: machine.isRunning)
        }
        .onAppear {
            fetchReasonCounts()
        }
    }

    func fetchReasonCounts() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Machine_Diary")
        
        for i in 0..<reasons.count {
            let reason = reasons[i]
            collectionRef
                .whereField("machineID", isEqualTo: machineID)
                .whereField("reasonID", isEqualTo: reason.reasonID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    reasons[i].count = documents.count
                }
        }
    }
}

struct MachineControlView_Previews: PreviewProvider {
    static var previews: some View {
        MachineControl()
    }
}

