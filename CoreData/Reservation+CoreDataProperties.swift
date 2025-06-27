//
//  Reservation+CoreDataProperties.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 10/06/25.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged public var customerEmail: String?
    @NSManaged public var customerName: String?
    @NSManaged public var customerPhoneNumber: String?
    @NSManaged public var id: UUID?
    @NSManaged public var party: Int16
    @NSManaged public var reservationDate: Date?
    @NSManaged public var reservationNotes: String?
    @NSManaged public var fromLocation: Location?

}

extension Reservation : Identifiable {

    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        request.relationshipKeyPathsForPrefetching = ["fromLocation"]
        request.includesPropertyValues = true
        return request
        
    }
    
    static func deleteAll(_ context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Reservation.fetchRequest()
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
    
    
    class func readAll(_ context:NSManagedObjectContext) -> [Reservation]? {
        let request = Reservation.request()
        request.sortDescriptors = [
            NSSortDescriptor(key: "reservationDate",
                             ascending: true,
                             selector:
                                #selector(NSString.localizedStandardCompare)
                            )
        ]
        do {
            guard let results = try context.fetch(request) as? [Reservation],
                  results.count > 0 else { return nil }
            return results
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    
}

