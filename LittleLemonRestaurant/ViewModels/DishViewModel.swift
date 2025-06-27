import Foundation
import CoreData


@MainActor
class DishViewModel: ObservableObject {
    
    @Published var searchText = "";
    @Published var scrollPosition: Int? = nil
    @Published var alreadyFetched: Bool = false
    
    func fetchMenuItems(_ coreDataContext:NSManagedObjectContext) async {
        let url = URL(string: ApiConst.littleLemonMenuUrl)!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let fullMenu = try JSONDecoder().decode(MenuStruct.self, from: data)
            
            // populate Core Data
            Dish.saveAll(menuItems: fullMenu.menu, coreDataContext)
        }
        catch {
            print(error)
        }
        
        /*let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/littleLemonSimpleMenu.json")!
         let urlSession = URLSession.shared
         let task = urlSession.dataTask(with: url) { data, response, error in
         if let error = error {
         print("Errore: \(error)")
         return
         }
         guard let data = data else {
         print("Nessun dato ricevuto")
         return
         }
         do {
         let fullMenu = try JSONDecoder().decode(JSONMenu.self, from: data)
         // Esegui su MainActor (cioè thread principale)
         Task { @MainActor in
         self.menuItems = fullMenu.menu
         // Aggiorna Core Data sul main thread, se il context è main queue
         Dish.deleteAll(coreDataContext)
         Dish.createDishesFrom(menuItems: self.menuItems, coreDataContext)
         }
         } catch {
         print("Errore di decoding: \(error)")
         }
         
         }
         task.resume()*/
    }
}

