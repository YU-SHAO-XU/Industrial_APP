import Foundation

struct User : Identifiable, Codable{
    
    let id : String
    var name: String
    var date: String
    var product: String
    var quantity: String
    var delivery: String
    
}

extension User {
    
    static var Mock_User: [User] = [
        
        .init(id: NSUUID().uuidString, name: "A", date: "12/29", product: "竹版", quantity: "100", delivery: "1/1" ),
        .init(id: NSUUID().uuidString, name: "A", date: "12/29", product: "竹版", quantity: "100", delivery: "1/1" ),
        .init(id: NSUUID().uuidString, name: "A", date: "12/29", product: "竹版", quantity: "100", delivery: "1/1" ),
        .init(id: NSUUID().uuidString, name: "A", date: "12/29", product: "竹版", quantity: "100", delivery: "1/1" ),
        .init(id: NSUUID().uuidString, name: "A", date: "12/29", product: "竹版", quantity: "100", delivery: "1/1" ),
    ]
}
