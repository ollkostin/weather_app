import Foundation
import CoreData

enum RetrieveError : Error {
    case error (key : String)
}

class WeatherService {
    private let session : URLSession = URLSession(configuration: .default)
    public var viewContext : NSManagedObjectContext
    private let parser : WeatherParseable
    private var saver : WeatherSaveable
    init(container : DataBaseContainable) {
        self.parser = YahooWeatherParser()
        self.viewContext = container.viewContext
        self.saver = WeatherCoreDataSaver(container: container)
    }
    
    func deleteLocation(location : LocationMO) {
        do {
            try viewContext.delete(location)
        } catch {
            print(error)
        }
    }

    func retrieveWeather(for location : String) throws {
        guard let url =
            URL(string : urlForForecast(with: location)!)
            else {
                throw RetrieveError.error(key: "Error occured while retrieving weather")
        }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            do {
                if let data = data {
                    let weather = try self.parser.parse(data: data)
                    try self.saver.save(weather: weather)
                }
                if let error = error {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func retrieveWeather() throws {
        let request : NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        let result = try viewContext.fetch(request)
        for location in result {
            try retrieveWeather(for : location.name!)
        }
    }
        
    func urlForForecast(with name : String) -> String? {
        let requestString = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(name)\")and u=\'c\'"
        guard let encoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        let endPoint = "https://query.yahooapis.com/v1/public/yql?q=\(encoded)&format=json"
        return endPoint
    }

}
