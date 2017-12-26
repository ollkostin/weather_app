import Foundation
import CoreData


public class LocationMO: NSManagedObject {

    class func createOrUpdate(with name: String, context : NSManagedObjectContext)
        -> LocationMO {
        
        let request : NSFetchRequest<LocationMO> = LocationMO.fetchRequest() as NSFetchRequest<LocationMO>
        request.predicate = NSPredicate(format: "name = %@", name)
        var location : LocationMO?
        var result : [LocationMO]
        do {
            result = try context.fetch(request)
            if result.count == 0 {
                location = LocationMO(context: context)
            } else if let firstItem = result.first,result.count == 1 {
                location = firstItem
            } else {
                assertionFailure("smth went wrong")
                location = LocationMO(context: context)
            }
            location?.name = name
        } catch {
            print(error)
        }
            
        return location!
    }
    

}
