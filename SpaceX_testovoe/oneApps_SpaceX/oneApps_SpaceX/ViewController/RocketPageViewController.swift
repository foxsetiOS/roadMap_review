import UIKit
import SnapKit

class RocketPageViewController: UIPageViewController {
    
    private let viewModel: RocketPageViewModel
    private var rocketDetailViewControllers: [RocketDetailViewController] = []
    private let pageControl = UIPageControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var onShowLaunches: ((String) -> Void)?
    var onShowSettings: (() -> Void)?
    
    init(viewModel: RocketPageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.FatalError.initCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        viewModel.loadRockets()
    }
    

    private func setupUI() {
        view.backgroundColor = .black
        dataSource = self
        delegate = self
        
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.addTarget(self, action: #selector(handlePageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(90)
            $0.height.equalTo(Constants.pageControlHeight)
        }
        pageControl.alpha = 0 // скрыт по умолчанию

        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        //  элементы навигации обновлены при inp данных
        configureNavigationItems(for: 0)
    }
    
    private func setupBindings() {
        viewModel.rockets.bind { [weak self] rockets in
            guard
                rockets.isNotEmpty
            else {
                return
            }
            self?.createViewControllers(for: rockets)
            self?.setupInitialViewController()
            self?.pageControl.numberOfPages = rockets.count
            self?.pageControl.currentPage = 0
        }
        
        viewModel.currentIndex.bind { [weak self] index in
            self?.pageControl.currentPage = index
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            isLoading ? self?.showLoader() : self?.hideLoader()
        }
    }
    
    private func createViewControllers(for rockets: [Rocket]) {
        rocketDetailViewControllers = rockets.map { rocket in
            let detailViewModel = RocketDetailViewModel(
                rocketId: rocket.id,
                networkService: DIContainer.shared.networkService,
                settingsManager: SettingsManager.shared
            )
            let detailViewController = RocketDetailViewController(viewModel: detailViewModel)
            detailViewController.onPageControlVisibilityChange = { [weak self] isVisible in
                UIView.animate(withDuration: 0.2) {
                    self?.pageControl.alpha = isVisible ? 1 : 0
                }
            }
            
            detailViewController.onShowLaunches = { [weak self] rocketId in
                self?.onShowLaunches?(rocketId)
            }
            
            detailViewController.onShowSettings = { [weak self] in
                self?.onShowSettings?()
            }
            
            return detailViewController
        }
    }
    
    private func setupInitialViewController() {
        guard
            rocketDetailViewControllers.isNotEmpty
        else {
            return
        }
        setViewControllers([rocketDetailViewControllers[0]], direction: .forward, animated: true, completion: nil)
        configureNavigationItems(for: 0)
    }
    
    private func showLoader() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicator.stopAnimating()
    }
    
    @objc private func handlePageControlChanged(_ sender: UIPageControl) {
        let targetIndex = sender.currentPage
        guard
            targetIndex >= 0, targetIndex < rocketDetailViewControllers.count
        else {
            return
        }
        
        let currentIndex = viewModel.currentIndex.value
        let direction: UIPageViewController.NavigationDirection = targetIndex >= currentIndex ? .forward : .reverse
        setViewControllers([rocketDetailViewControllers[targetIndex]], direction: direction, animated: true, completion: nil)
        // При смене страницы скрываем индикатор до тех пор, пока пользователь не доскроллит вниз
        pageControl.alpha = 0
        viewModel.currentIndex.value = targetIndex
        configureNavigationItems(for: targetIndex)
    }
}

extension RocketPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let detailViewController = viewController as? RocketDetailViewController,
            let index = rocketDetailViewControllers.firstIndex(where: { $0 === detailViewController }),
              index > 0
        else {
            return nil
        }
        
        return rocketDetailViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let detailViewController = viewController as? RocketDetailViewController,
            let index = rocketDetailViewControllers.firstIndex(where: { $0 === detailViewController }),
              index < rocketDetailViewControllers.count - 1
        else {
            return nil
        }
        
        return rocketDetailViewControllers[index + 1]
    }
}

extension RocketPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let currentViewController = pageViewController.viewControllers?.first as? RocketDetailViewController,
            let currentIndex = rocketDetailViewControllers.firstIndex(where: { $0 === currentViewController })
        else {
            return
        }
        
        viewModel.currentIndex.value = currentIndex
        configureNavigationItems(for: currentIndex)
        if completed {
            // После завершения перелистывания скрываем индикатор, он появится при доскролле вниз
            pageControl.alpha = 0
        }
    }
}

private extension RocketPageViewController {
    
    func configureNavigationItems(for index: Int) {
        if let rocket = viewModel.rocket(at: index) {
            navigationItem.title = rocket.name
        }
        
        let settingsImage = UIImage(named: String.AssetName.setting)?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(handleSettingsTap))
        settingsButton.tintColor = .white
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func handleSettingsTap() {
        onShowSettings?()
    }
}


