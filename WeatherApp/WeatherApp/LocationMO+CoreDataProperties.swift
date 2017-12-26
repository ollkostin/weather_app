import Foundation
import CoreData


extension LocationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationMO> {
        return NSFetchRequest<LocationMO>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var weather: WeatherMO?

}
