import Foundation
import SwiftUI
import CoreData

struct FetchedObjects<T, Content>: View where T : NSManagedObject, Content : View {
    
    let content: ([T]) -> Content

    var request: FetchRequest<T>
    var results: FetchedResults<T> { request.wrappedValue }
    
    init(
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping ([T]) -> Content
    ) {
        self.content = content
        // Crea la NSFetchRequest direttamente
        let fetchRequest = NSFetchRequest<T>(entityName: T.entity().name!)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        self.request = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        self.content(Array(results))
    }
}
