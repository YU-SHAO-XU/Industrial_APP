/*
 import SwiftUI
 import Charts
 import FirebaseFirestore

 struct Machine: Identifiable {
     var id = UUID() // 這個 UUID 用來作為 SwiftUI 列表中元素的唯一標識符
     var machineID: String // 用來作為 Firebase 中機器的唯一標識符
     var name: String
     var description: String
     var isRunning: Bool // true 表示運作，false 表示停止
     
     // 初始化方法，指定機器ID
     init(machineID: String, name: String, description: String, isRunning: Bool) {
         self.machineID = machineID
         self.name = name
         self.description = description
         self.isRunning = isRunning
     }
 }



 struct MachineControl: View {
     @State private var machines = [
         Machine(machineID: "1", name: "竹管定長機 \n CORTADORA BAMBÚ", description: "Description 1",isRunning : true),
         Machine(machineID: "2", name: "竹條取片機 \n CORTADORA PARA FAJAS", description: "Description 2",isRunning : true),
         Machine(machineID: "3", name: "連環式竹節修平機-1 \n CEPILLADORAS 2 CARAS-1", description: "Description 3",isRunning : true),
         Machine(machineID: "4", name: "連環式竹節修平機-2 \n CEPILLADORAS 2 CARAS-2", description: "Description 4",isRunning : true),
         Machine(machineID: "5", name: "竹條修平機-1 \n CEPILLADORA 2 CARAS-1", description: "Description 5",isRunning : true),
         Machine(machineID: "6", name: "竹條修平機-2 \n CEPILLADORA 2 CARAS-2", description: "Description 6",isRunning : true),
         Machine(machineID: "7", name: "熱處理機 \n TINA", description: "Description 7",isRunning : true),
         Machine(machineID: "8", name: "碳化爐 \n CARBONIZADORA", description: "Description 8",isRunning : true),
         Machine(machineID: "9", name: "四面鉋 \n CEPILLADORA 4 CARAS", description: "Description 9",isRunning : true),
         Machine(machineID: "10", name: "佈膠 \n ENCOLADORA", description: "Description 10",isRunning : true),
         Machine(machineID: "11", name: "多軸開槽機 \n MOLDURADORA", description: "Description 11",isRunning : true),
         Machine(machineID: "12", name: "熱壓機 \n PRENSA", description: "Description 12",isRunning : true),
         Machine(machineID: "13", name: "砂磨機 \n LIJADORA", description: "Description 13",isRunning : true),
         Machine(machineID: "14", name: "桌上型圓鋸機 \n SIERRAS RADIALES", description: "Description 14",isRunning : true),
         Machine(machineID: "15", name: "單面鋸直機 \n SIERRA BANDEADORA", description: "Description 15",isRunning : true),
         Machine(machineID: "16", name: "雷射雕刻機 \n LASER", description: "Description 16",isRunning : true),
     ]

     
     var body: some View {
         NavigationView {
                     ScrollView {
                         LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                             ForEach(machines) { machine in
                                 NavigationLink(destination: MachineDetail(isRunning: $machines[machineIndex(machine)].isRunning, machineID: machine.machineID)){
                                     MachineButton(machine: machine)
                                 }

                                 .padding()
                             }
                         }
                         .padding() // 添加一些內側填充以增加滑動區域
                     }
                     .listStyle(PlainListStyle()) // 移除列表的分隔線
                     .navigationBarTitle("Machine", displayMode: .inline) // 置中標題並移除留白
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
             .foregroundColor(.black) // 設定文字為黑色
             .truncationMode(.tail)
             .padding(8) // 添加內邊距，使外框顯示更清晰
             .background(
                 RoundedRectangle(cornerRadius: 8) // 設定圓角矩形的圓角半徑
                     .stroke(machine.isRunning ? Color.green : Color.red, lineWidth: 5) // 添加綠色或紅色外框
             )
     }
 }




import SwiftUI
import Charts
 
 struct MachineDetail: View {
     
     struct ReasonItem: Identifiable {
         var id = UUID()
         var reason: String
         var machineID: String // 機台的唯一標識符
         var reasonID: String // 故障原因的唯一標識符
         var count: Int
     }
     @Binding var isRunning: Bool
     @State private var reasons: [ReasonItem] = [
         ReasonItem(reason: "工人操作不當", machineID: "", reasonID: "1", count: 0),
         ReasonItem(reason: "設備老化", machineID: "", reasonID: "2", count: 0),
         ReasonItem(reason: "原料欠缺", machineID: "", reasonID: "3", count:0 ),
         ReasonItem(reason: "其他", machineID: "", reasonID: "4", count: 0),
     ]
     @Environment(\.dismiss) var dismiss
     let machineID: String // 這裡將機器ID改為String類型
     
     var body: some View {
             VStack {
                 Chart(reasons) { reason in
                     SectorMark(
                         angle: .value(Text(verbatim: reason.reason), reason.count),
                         innerRadius: .ratio(0.618), angularInset: 1.5
                     )
                     .foregroundStyle(by: .value(
                         Text(verbatim: reason.reason),
                         String(reason.reason)
                     ))
                 }
                 .frame(width: 350, height: 300) // 設定圖表的寬度和高度
                 
                 VStack {
                     List {
                         HStack {
                             Text("故障原因")
                                 .frame(maxWidth: .infinity, alignment: .leading)
                             
                             Text("次數")
                                 .frame(maxWidth: .infinity, alignment: .trailing)
                         }
                         .listRowBackground(Color.gray) // 整個 HStack 背景色
                         
                         ForEach(reasons, id: \.reason) { item in
                             NavigationLink(destination: ReasonRecord(machineID: machineID, reasonID: item.reasonID)) {
                                 Text(item.reason)
                                     .font(.callout)
                                     .lineLimit(2)
                                     .foregroundColor(.black) // 設置文字顏色為黑色
                                     .truncationMode(.tail)
                             }
                         }
                     }
                     .listStyle(PlainListStyle()) // 移除 List 的背景色
                 }
                  Toggle("機台狀態", isOn: $isRunning)
                      .padding()
             }
             .navigationTitle("故障原因分析") // 設置標題
             .navigationBarTitleDisplayMode(.inline) // 設置標題顯示模式
         
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
     .onAppear {
         fetchReasonCounts()
 }
     }
 func fetchReasonCounts() {
     let db = Firestore.firestore()
     let collectionRef = db.collection("Machine_Diary")
     
     // Loop through each reason item to fetch count
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

*/
