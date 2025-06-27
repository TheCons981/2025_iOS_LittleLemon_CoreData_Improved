import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var model: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @StateObject var locationViewModel: LocationViewModel
    @StateObject var dishViewModel: DishViewModel
    @StateObject var reservationViewModel: ReservationViewModel
    
    @State var tabSelection = 0
    @State var previousTabSelection = -1 // any invalid value
    
    
    init() {
        _locationViewModel = StateObject(wrappedValue: LocationViewModel(context: PersistenceController.shared.container.viewContext))
        _dishViewModel = StateObject(wrappedValue: DishViewModel())
        _reservationViewModel = StateObject(wrappedValue: ReservationViewModel())
    }
    
    var body: some View {
        ZStack{
            
            
            TabView (selection: $model.tabViewSelectedIndex){
                LocationsView()
                    .tag(0)
                    .tabItem {
                        Label("Locations", systemImage: "fork.knife")
                    }
                    .onAppear() {
                        tabSelection = 0
                    }
                    .environmentObject(locationViewModel)
                    .environmentObject(reservationViewModel)
                    .environmentObject(networkMonitor)
                
                DishesView()
                    .tag(1)
                    .tabItem {
                        Label("Our Dishes", systemImage: "fork.knife.circle")
                    }
                    .onAppear() {
                        tabSelection = 1
                    }
                    .environmentObject(dishViewModel)
                    .environmentObject(networkMonitor)
                
                
                ReservationView()
                    .tag(2)
                    .tabItem {
                        Label("Reservation", systemImage: "square.and.pencil")
                    }
                    .onAppear() {
                        tabSelection = 2
                    }
                    .environmentObject(reservationViewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(model)
            .onChange(of: networkMonitor.isConnected) { prevIsconnected, isConnected in
                let bannerMessage = isConnected ? "Network connection restored" : "Network connection lost"
                let bannerColor = isConnected ? "green" : "red"
                model.networkBanner = Banner(message: bannerMessage, color: bannerColor, show: true)
                
                //hide after some secs
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        model.networkBanner = Banner(message: "", color: "", show: false)
                    }
                }
            }
            
            // Banner overlay
            if model.networkBanner.show {
                VStack {
                    HStack {
                        Spacer()
                        Text(model.networkBanner.message)
                            .foregroundColor(.white)
                            .padding()
                            .background(model.networkBanner.colorScheme)
                            .cornerRadius(10)
                        Spacer()
                    }
                    .padding(.top, 50)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppViewModel())
            .environmentObject(NetworkMonitor.shared)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        
    }
}




