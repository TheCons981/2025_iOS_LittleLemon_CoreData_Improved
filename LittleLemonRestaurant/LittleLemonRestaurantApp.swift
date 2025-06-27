import SwiftUI

@main
struct LittleLemonRestaurantApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var model = AppViewModel()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
                .environmentObject(networkMonitor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
