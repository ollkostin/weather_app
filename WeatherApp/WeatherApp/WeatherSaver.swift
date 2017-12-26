import Foundation
import CoreData

protocol WeatherSaveable{
    func save(weather : Weather) throws
}

class WeatherCoreDataSaver : WeatherSaveable{
    private let container: DataBaseContainable
    
    init(container: DataBaseContainable) {
        self.container = container
    }
    
    func save(weather : Weather) throws {
        var forecastList : [ForecastMO] = []
        for item in weather.forecasts {
            let forecastMO = try ForecastMO.createOrUpdate(with : item, context:  container.viewContext)
            forecastList.append(forecastMO)
        }
        let weatherMO = try WeatherMO.create(context :  container.viewContext)
        weatherMO.forecasts = Set(forecastList) as NSSet?
        let location = try LocationMO.createOrUpdate(with : weather.location, context : container.viewContext)
        location.weather = weatherMO
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    }
}
