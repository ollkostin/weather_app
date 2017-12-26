import Foundation
import CoreData

protocol CoreDataProtocol {
    var persistentContainer : NSPersistentContainer { get }
    func save(context : NSManagedObjectContext) throws
}

class CoreDataManager : CoreDataProtocol {
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherModel")
        container.loadPersistentStores() {
            (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error.userInfo)")
            }
        }
        return container
    }()
    
    func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
}
