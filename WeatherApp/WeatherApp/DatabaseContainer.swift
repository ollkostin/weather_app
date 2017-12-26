import Foundation
import CoreData

protocol DataBaseContainable {
    
    var viewContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

class DataBaseContainer: DataBaseContainable {
    
    private lazy var coreDataManager: CoreDataManager = {
        return CoreDataManager()
    }()
    
    private var container: NSPersistentContainer {
        return coreDataManager.persistentContainer
    }
    
    var viewContext: NSManagedObjectContext {
        let viewContext = container.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }
    
    var saveContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
}
