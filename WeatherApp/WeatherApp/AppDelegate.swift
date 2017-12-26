import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    var container: DataBaseContainable!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        container = DataBaseContainer()
        return true
    }
}

extension UIApplication {
    
    static var container: DataBaseContainable {
        if let delegate = shared.delegate as? AppDelegate {
            return delegate.container
        } else {
            return DataBaseContainer()
        }
    }
}


