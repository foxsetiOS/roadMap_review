import UIKit

@MainActor
final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        setupNavigationBar()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        showWelcomeScreen()
    }
}

private extension AppCoordinator {
    
    private func setupNavigationBar() {
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
    }
    
    func showWelcomeScreen() {
        let viewModel = WelcomeViewModel()
        let viewController = WelcomeViewController(viewModel: viewModel)
        viewModel.onStartButtonTapped = { [weak self] in
            self?.showRocketPage()
        }
        navigationController.viewControllers = [viewController]
    }
    
    func showRocketPage() {
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
    
    func showLaunches(rocketId: String) {
        let viewModel = LaunchListViewModel(rocketId: rocketId)
        let viewController = LaunchListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSettings() {
        let viewModel = SettingsViewModel(settingsManager: SettingsManager.shared)
        let settingsVC = SettingsViewController(viewModel: viewModel)
        let sheetNavigationController = UINavigationController(rootViewController: settingsVC)
        setupSettingsNavigation(sheetNavigationController)
        navigationController.present(sheetNavigationController, animated: true)
    }
    
    private func setupSettingsNavigation(_ navigationController: UINavigationController) {
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .colorText
        navigationController.modalPresentationStyle = .popover
        
        navigationController.sheetPresentationController?.configure {
            $0.detents = [.medium(), .large()]
            $0.prefersGrabberVisible = true
            $0.preferredCornerRadius = 16
        }
    }
}

private extension UISheetPresentationController {
    func configure(_ block: (UISheetPresentationController) -> Void) {
        block(self)
    }
}
