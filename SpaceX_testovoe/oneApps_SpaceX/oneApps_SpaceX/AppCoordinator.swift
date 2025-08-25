import UIKit

@MainActor final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        showWelcomeScreen()
    }
    
    private func showWelcomeScreen() {
        let viewModel = WelcomeViewModel()
        let viewController = WelcomeViewController(viewModel: viewModel)
        viewModel.onStartButtonTapped = { [weak self] in
            self?.showRocketPage()
        }
        navigationController.viewControllers = [viewController]
    }
    
    private func showRocketPage() {
        let viewModel = RocketPageViewModel()
        let viewController = RocketPageViewController(viewModel: viewModel)
        viewController.onShowLaunches = { [weak self] rocketId in
            self?.showLaunches(rocketId: rocketId)
        }
        viewController.onShowSettings = { [weak self] in
            self?.showSettings()
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showRocketDetail(rocketId: String) {
        let viewModel = RocketDetailViewModel(
            rocketId: rocketId,
            networkService: DiContainer.shared.networkService,
            settingsManager: SettingsManager.shared
        )
        let viewController = RocketDetailViewController(viewModel: viewModel)
        viewController.onShowLaunches = { [weak self] rocketId in
            self?.showLaunches(rocketId: rocketId)
        }
        viewController.onShowSettings = { [weak self] in
            self?.showSettings()
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
     private func showLaunches(rocketId: String) {
        let viewModel = LaunchListViewModel(
            rocketId: rocketId,
            networkService: DiContainer.shared.networkService
        )
        let viewController = LaunchListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showSettings() {
        let viewModel = SettingsViewModel()
        let settingsVC = SettingsViewController(viewModel: viewModel)
        let sheetNavigationSettings = UINavigationController(rootViewController: settingsVC)
        sheetNavigationSettings.navigationBar.barStyle = .black
        sheetNavigationSettings.navigationBar.tintColor = .colorText
        sheetNavigationSettings.modalPresentationStyle = .popover
        if let sheet = sheetNavigationSettings.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        navigationController.present(sheetNavigationSettings, animated: true)
    }
}
