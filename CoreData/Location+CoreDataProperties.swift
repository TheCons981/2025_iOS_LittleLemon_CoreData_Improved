import Foundation
import CoreData


extension Location {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var city: String?
    @NSManaged public var neighborhood: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var toCustomer: NSSet?
    @NSManaged public var toDessert: NSSet?
    @NSManaged public var toDish: NSSet?
    
}

extension Location : Identifiable {
    
    static func request() -> NSFetchRequest<Location> {
        let request: NSFetchRequest<Location> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
    
    static func delete(with phoneNumber: String,
                       _ context:NSManagedObjectContext) -> Bool {
        let request = Location.request()
        
        let predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish],
                  results.count == 1,
                  let location = results.first
            else {
                return false
            }
            context.delete(location)
            return true
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    
    static func deleteAll(_ context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
            try context.save()
        } catch {
            print("Errore durante la cancellazione: \(error)")
        }
    }
    
    
    static func save(_ context:NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    class func readAll(_ context:NSManagedObjectContext, searchTerm: String? = nil) -> [Location]? {
        let request = Location.request()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "city",
                             ascending: true,
                             selector:
                                #selector(NSString.localizedStandardCompare)
                            )
        ]
        
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            let predicate1 = NSPredicate(format: "city CONTAINS[cd] %@", searchTerm)
            let predicate2 = NSPredicate(format: "phoneNumber CONTAINS[cd] %@", searchTerm)
            let predicate3 = NSPredicate(format: "neighborhood CONTAINS[cd] %@", searchTerm)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
            
            request.predicate = compoundPredicate
        }

        do {
            guard let results = try context.fetch(request) as? [Location],
                  results.count > 0 else { return nil }
            return results
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func with(_ context:NSManagedObjectContext, city: String, phoneNumber: String) -> Location? {
        let request = Location.request()
        let predicate1 = NSPredicate(format: "city == %@", city)
        let predicate2 = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        
        request.predicate = compoundPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "city",
                                              ascending: false,
                                              selector: #selector(NSString .localizedStandardCompare))
        request.sortDescriptors = [sortDescriptor]
        
        do {
            guard let results = try context.fetch(request) as? [Location],
                  results.count > 0,
                  let location = results.first
            else { return Location(context: context) }
            return location
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getBatchSearchFetchRequest(searchTerm: String? = nil) -> NSFetchRequest<Location> {
        let request = Location.request()
        request.fetchBatchSize = 20
        request.sortDescriptors = [
            NSSortDescriptor(key: "city",
                             ascending: true,
                             selector:
                                #selector(NSString.localizedStandardCompare)
                            )
        ]
        
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            let predicate1 = NSPredicate(format: "city CONTAINS[cd] %@", searchTerm)
            let predicate2 = NSPredicate(format: "phoneNumber CONTAINS[cd] %@", searchTerm)
            let predicate3 = NSPredicate(format: "neighborhood CONTAINS[cd] %@", searchTerm)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
            
            request.predicate = compoundPredicate
        }

        return request;
    }
    
}
