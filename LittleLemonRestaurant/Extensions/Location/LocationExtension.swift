//
// Dish+Extension.swift



import Foundation
import CoreData


extension Location {
    
    static func saveAll(locations:[LocationStruct],
                        _ context:NSManagedObjectContext) {
        for location in locations {
            if exists(phoneNumber: location.phoneNumber, context) {
                continue
            }
            
            let oneLocation = Location(context: context)
            oneLocation.phoneNumber = location.phoneNumber
            oneLocation.neighborhood = location.neighborhood
            oneLocation.city = location.city
            Location.save(context)
        }
    }
    
    
    static func exists(phoneNumber: String,
                       _ context:NSManagedObjectContext) -> Bool {
        let request = Location.request()
        let predicate = NSPredicate(format: "phoneNumber CONTAINS[cd] %@", phoneNumber)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Location]
            else {
                return false
            }
            return results.count > 0
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    
    public static func mapToLocationStruct(location: Location) -> LocationStruct {
        let restaurantLocation = LocationStruct(city: location.city!, neighborhood: location.neighborhood!, phoneNumber: location.phoneNumber!);
        
        return restaurantLocation;
    }
    
    // Questo init viene chiamato ogni volta che Core Data crea un oggetto "materializzato"
       public override func awakeFromFetch() {
           super.awakeFromFetch()
           print("[LOG] Location materializzata: \(city ?? "?") - \(phoneNumber ?? "?")")
       }

}
