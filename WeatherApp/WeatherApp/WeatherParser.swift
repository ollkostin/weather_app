import Foundation

enum ParseError : Error {
    case wrongStructure(key : String)
    case wrongDateFormat(key : String)
}

protocol WeatherParseable {
    func parse(data : Data) throws -> Weather
}

class YahooWeatherParser : WeatherParseable {
    private let dateFormat = "dd MMM yyyy"
    
    func parse(data : Data) throws -> Weather {
        var json :[String: Any]?
        var weather = Weather()
        
        do {
            json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let query = json?["query"] as? [String: Any] else {
                throw ParseError.wrongStructure(key: "no query")
            }
            guard let results = query["results"] as? [String: Any] else {
                throw ParseError.wrongStructure(key: "no results")
            }
            guard let channel = results["channel"] as? [String: Any] else {
                throw ParseError.wrongStructure(key: "no channel")
            }
            
            guard let location = (channel["location"] as? [String:Any])?["city"] as? String else {
                throw ParseError.wrongStructure(key: "no city in location")
            }

            guard let item = channel["item"] as? [String: Any] else {
                throw ParseError.wrongStructure(key: "no item")
            }
            guard let forecast = item["forecast"] as? [[String: Any]] else {
                throw ParseError.wrongStructure(key: "no forecast")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.dateFormat
            var forecastList : [ForecastItem] = []
            for forecastItem in forecast {
                var item = ForecastItem()
                guard let date = dateFormatter.date(from:forecastItem["date"] as! String) else {
                    throw ParseError.wrongDateFormat(key:"wrong date format")
                }
                item.date = date
                item.low = Int16((forecastItem["low"] as! String))!
                item.high = Int16((forecastItem["high"] as! String))!
                item.info = forecastItem["text"] as! String
                item.location = location
                forecastList.append(item)
            }
            weather.location = location
            weather.forecasts = forecastList
        } catch {
            print(error)
        }
        return weather
    }
    
    
}
