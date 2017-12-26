import Foundation
import CoreData


extension ForecastMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastMO> {
        return NSFetchRequest<ForecastMO>(entityName: "Forecast")
    }

    @NSManaged public var info: String?
    @NSManaged public var low: Int16
    @NSManaged public var high: Int16
    @NSManaged public var date: Date?
    @NSManaged public var weather: WeatherMO?

}
