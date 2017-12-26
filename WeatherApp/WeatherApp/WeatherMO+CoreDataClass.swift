import Foundation
import CoreData


public class WeatherMO: NSManagedObject {
    
    class func create(context: NSManagedObjectContext) throws -> WeatherMO {
        let weatherMO = WeatherMO(context: context)
        return weatherMO
    }
}
