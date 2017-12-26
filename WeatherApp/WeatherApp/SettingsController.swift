import Foundation
import UIKit
import CoreData

class SettingsController : UIViewController, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var inputCityTextField: UITextField!
    @IBOutlet weak var getForecastButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var service = WeatherService(container: UIApplication.container)
    private lazy var weatherService = WeatherService(container : UIApplication.container)
    
    private lazy var fetchedResultsController :  NSFetchedResultsController<LocationMO> = {
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
        performFetch()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        inputCityTextField.delegate = self
    }
    
    func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if let objects = fetchedResultsController.fetchedObjects {
                let item = objects[indexPath.row]
                service.deleteLocation(location: item)
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        do {
            try service.retrieveWeather(for : inputCityTextField.text!)
            inputCityTextField.text! = ""
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        if let locationCell = cell as? LocationCell,
            let items = fetchedResultsController.fetchedObjects {
            locationCell.nameLabel.text =  items[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = fetchedResultsController.fetchedObjects
            else { return 0 }
        return objects.count
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (inputCityTextField.text! as NSString).replacingCharacters(in: range, with: string)
        getForecastButton.isEnabled = !text.isEmpty
        return true
    }
}

extension SettingsController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
