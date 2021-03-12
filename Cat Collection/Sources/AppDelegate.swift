import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		let catAPIService = CatAPIService()
		let catCollectionVM = CatCollectionViewModel(catAPIService: catAPIService)
		let catCollectionVC = CatCollectionViewController(viewModel: catCollectionVM)
		let navigationController = UINavigationController(rootViewController: catCollectionVC)
		navigationController.navigationBar.prefersLargeTitles = true

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		return true
	}

}

