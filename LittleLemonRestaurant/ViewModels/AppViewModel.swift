import Foundation
import CoreData

@MainActor
class AppViewModel:ObservableObject {
    @Published var networkBanner = Banner()
    @Published var tabBarChanged = false
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}
