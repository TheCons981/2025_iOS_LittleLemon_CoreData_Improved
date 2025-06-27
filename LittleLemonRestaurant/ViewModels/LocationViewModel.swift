import Foundation
import CoreData

class LocationViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var locations = [Location]()
    @Published var searchText = "";
    @Published var scrollPosition: Int? = nil
    @Published var alreadyFetched: Bool = false
    
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<Location>!
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    func fetchRestaurants(_ coreDataContext:NSManagedObjectContext) async {
        
        let url = URL(string: ApiConst.littleLemonLocationsUrl)!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fetchedRestaurants = try JSONDecoder().decode([LocationStruct].self, from: data)
            //restaurants = fetchedRestaurants.sorted { $0.city < $1.city }
            
            // populate Core Data. the method add only new elements.
            //Location.deleteAll(coreDataContext)
            Location.saveAll(locations: fetchedRestaurants, coreDataContext)
            refresh();
        }
        catch {
            print(error)
        }
    }
    
    func setupFetchedResultsController() {
        
        let request = Location.getBatchSearchFetchRequest(searchTerm: searchText)
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.locations = self.fetchedResultsController.fetchedObjects ?? []
                }
            
        } catch {
            print("Fetch error: \(error)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let locs = controller.fetchedObjects as? [Location] {
            self.locations = locs
        }
    }

    func refresh() {
        setupFetchedResultsController()
    }
   
}
