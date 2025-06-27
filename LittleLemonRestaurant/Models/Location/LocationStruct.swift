import Foundation

public struct LocationStruct: Hashable, Codable {
    public let city:String
    public let neighborhood:String
    public let phoneNumber:String
    
    init(city:String = "",
         neighborhood:String = "",
         phoneNumber:String = "") {
        self.city = city
        self.neighborhood = neighborhood
        self.phoneNumber = phoneNumber
    }
}


