import Foundation

struct MenuStruct: Codable {
    let menu: [MenuItemStruct]
}

struct MenuItemStruct: Hashable, Codable, Identifiable {
    var id: Int
    let title: String
    let price: String
    let size: String?
    
    func formatPrice() -> String {
        let convertedPrice: Float = Float(price) ?? 0
        let spacing = convertedPrice < 10 ? " " : ""
        return "$ " + spacing + String(format: "%.2f", convertedPrice)
    }
}
