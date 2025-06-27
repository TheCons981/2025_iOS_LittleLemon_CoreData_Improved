import SwiftUI
import CoreData

struct DishesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var dishViewModel: DishViewModel
    @State private var showAlert = false
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                LittleLemonLogoView()
                LittleLemonTitleView(title: "Menu")
                
                FetchedObjects(
                    predicate:buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) {
                    (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id:\.self) { dish in
                            let menuItem = Dish.mapToMenuItemStruct(dish: dish)
                            DishDetailView(menuItem)
                                .onTapGesture {
                                    showAlert.toggle()
                                }
                        }
                    }
                    .scrollPosition(id: $dishViewModel.scrollPosition)
                    .searchable(text: $dishViewModel.searchText,
                                prompt: "Search...")
                    .refreshable {
                        await fetchdishes()
                    }
                }
            }
        }
        // makes the list background invisible, default is gray
        .scrollContentBackground(.hidden)
        
       
        // runs when the view appears
        .task {
            if (!dishViewModel.alreadyFetched) {
                await fetchdishes()
                dishViewModel.alreadyFetched = true
            }
        }
        .alert("Order placed, thanks!",
               isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
        // SwiftUI has this space between the title and the list
        // that is amost impossible to remove without incurring
        // into complex steps that run out of the scope of this
        // course, so, this is a hack, to bring the list up
        // try to comment this line and see what happens.
        //.padding(.top, -10)//
        
    }
    
    private func fetchdishes() async {
        if(networkMonitor.isConnected){
            await dishViewModel.fetchMenuItems(viewContext)
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        
        if !dishViewModel.searchText.isEmpty {
            let predicate1 = NSPredicate(format: "name CONTAINS[cd] %@", dishViewModel.searchText)
            let predicate2 = NSPredicate(format: "price CONTAINS[cd] %@", dishViewModel.searchText)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
            return compoundPredicate
        }
        else{
            return NSPredicate(value: true)
        }
    }
    
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "name",
                          ascending: true,
                          selector:
                            #selector(NSString.localizedStandardCompare))]
    }
}

struct DishesView_Previews: PreviewProvider {
    static var previews: some View {
        DishesView()
            .environmentObject(DishViewModel())
            .environmentObject(NetworkMonitor.shared)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}






