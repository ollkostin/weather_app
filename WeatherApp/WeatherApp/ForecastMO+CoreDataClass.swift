import Foundation
import CoreData


public class ForecastMO: NSManagedObject {

    class func createOrUpdate(with forecastItem: ForecastItem, context : NSManagedObjectContext) -> ForecastMO {
        let request : NSFetchRequest<ForecastMO> = ForecastMO.fetchRequest() as NSFetchRequest<ForecastMO>
        request.predicate = NSPredicate(format: "date = %@ AND weather.location.name = %@", forecastItem.date as CVarArg, forecastItem.location)
        var forecast : ForecastMO?
        var result : [ForecastMO]
        do {
            result = try context.fetch(request)
            if result.count == 0 {
                forecast = ForecastMO(context: context)
            } else if let firstItem = result.first,result.count == 1 {
                forecast = firstItem
            } else {
                assertionFailure("smth went wrong")
                forecast = ForecastMO(context: context)
            }
            forecast?.date = forecastItem.date
            forecast?.high = forecastItem.high
            forecast?.low = forecastItem.low
            forecast?.info = forecastItem.info
        } catch {
            print(error)
        }
        
        return forecast!
    }
    

}
