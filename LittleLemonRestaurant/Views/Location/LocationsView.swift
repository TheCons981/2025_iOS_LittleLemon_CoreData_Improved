import SwiftUI

struct LocationsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var model: AppViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var reservationViewModel: ReservationViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                LittleLemonLogoView()
                LittleLemonTitleView(title: "Locations")
                
                List(locationViewModel.locations, id: \.self) { location in
                    let restaurant = Location.mapToLocationStruct(location: location)
                    NavigationLink(destination: ReservationFormView(restaurant).environmentObject(reservationViewModel)) {
                        LocationView(restaurant)
                    }
                }
                .scrollPosition(id: $locationViewModel.scrollPosition)
                .searchable(text: $locationViewModel.searchText, prompt: "Search...")
                .refreshable {
                    await fetchRestaurants()
                }
                //.navigationBarTitle("")
                //.navigationBarHidden(true)
                //.background(NavigationBarNoCollapse())
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            if model.tabBarChanged { return }
        }
        .onChange(of: locationViewModel.searchText) {
            locationViewModel.refresh() //already contains the observed searchText value
        }
        .task {
            if (!locationViewModel.alreadyFetched) {
                await fetchRestaurants()
                locationViewModel.alreadyFetched = true
            }
        }
        
        .frame(maxHeight: .infinity)
        
        // SwiftUI has this space between the title and the list
        // that is amost impossible to remove without incurring
        // into complex steps that run out of the scope of this
        // course, so, this is a hack, to bring the list up
        // try to comment this line and see what happens.
        //.padding(.top, -10)
        
        // makes the list background invisible, default is gray
        .scrollContentBackground(.hidden)
        
    }
    
    private func fetchRestaurants() async {
        if(networkMonitor.isConnected){
            await locationViewModel.fetchRestaurants(viewContext)
        }
        else
        {
            locationViewModel.refresh()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        LocationsView()
            .environmentObject(AppViewModel())
            .environmentObject(ReservationViewModel())
            .environmentObject(LocationViewModel(context: context))
            .environmentObject(NetworkMonitor.shared)
            .environment(\.managedObjectContext, context)
    }
}
