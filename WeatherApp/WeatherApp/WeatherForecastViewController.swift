import UIKit
import CoreData

class WeatherForecastViewController: UITableViewController {
    private lazy var service = WeatherService(container: UIApplication.container)
    private let df = DateFormatter()
    @IBOutlet weak var locationLabel: UILabel!
    lazy var forecastFRC : NSFetchedResultsController<ForecastMO> = {
        let request : NSFetchRequest<ForecastMO> = ForecastMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:"weather.location.name",ascending : true),
                                   NSSortDescriptor(key: "date", ascending : true)]
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: self.service.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    lazy var locationFRC : NSFetchedResultsController<LocationMO> = {
        let request : NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending : true)]
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: self.service.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "dd MMM yyyy"
        performFetch()
        loadData()
    }
    
    func performFetch() {
        do {
            try forecastFRC.performFetch()
        } catch {
            print(error)
        }
    }
    
    public func loadData(){
        do {
            try service.retrieveWeather()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        if let forecastCell = cell as? ForecastCell,
            let items = forecastFRC.fetchedObjects {
                forecastCell.locationLabel.text = items[indexPath.row].weather?.location?.name
                forecastCell.dateLabel.text = df.string(for: items[indexPath.row].date)
                forecastCell.lowLabel.text = "↓ " + String(items[indexPath.row].low) + " C"
                forecastCell.highLabel.text = "↑ " + String(items[indexPath.row].high) + " C"
                forecastCell.infoLabel.text = "☼ " + items[indexPath.row].info!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = forecastFRC.fetchedObjects
        else { return 0 }
        return objects.count
    }
   }

extension WeatherForecastViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == forecastFRC {
            tableView.reloadData()
        } else if controller == locationFRC {
            performFetch()
            tableView.reloadData()
        }
    }
}
