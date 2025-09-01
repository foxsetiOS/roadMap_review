import UIKit
import SnapKit
import Kingfisher

final class RocketDetailViewController: UIViewController {
    private let viewModel: RocketDetailViewModel
    private let scrollView = UIScrollView()
    private let contentStackView = UIComponentsFactory.makeSectionStack()
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .medium, size: .title)
        label.textColor = Theme.Color.colorText
        return label
    }()
    
    var onShowLaunches: ((String) -> Void)?
    var onShowSettings: (() -> Void)?
    var onPageControlVisibilityChange: ((Bool) -> Void)?
    
    init(viewModel: RocketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.FatalError.initCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
        bindViewModel()
        viewModel.loadRocket()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.nasa,
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Обновляем constraints после того, как view получит свой размер
        scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
    }
    
    private func configureUserInterface() {
        view.backgroundColor = Theme.Color.colorView
        setupScrollView()
        setupContentStackView()
        setupHeader()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        scrollView.delegate = self
    }

    private func setupContentStackView() {
        scrollView.addSubview(contentStackView)
        // констрейнты для UIScrollView: ширина по frameLayoutGuide, высота по contentLayoutGuide
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(32)
            $0.width.equalTo(scrollView.frameLayoutGuide).inset(32)
        }
    }

    private func setupHeader() {
        headerImageView.snp.makeConstraints { $0.height.equalTo(Theme.Size.headerImageHeight) }
        contentStackView.addArrangedSubview(headerImageView)
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    private func bindViewModel() {
        viewModel.rocket.bind { [weak self] rocket in
            guard
                let rocket
            else {
                return
            }
            self?.updateUI(with: rocket)
        }
    }
    
    private func updateUI(with rocket: Rocket) {
        titleLabel.text = rocket.name
        
        if let imageUrl = rocket.flickrImages?.first {
            headerImageView.kf.setImage(
                with: URL(string: imageUrl),
                options: [
                    .transition(.fade(0.3)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 800, height: 600))),
                    .scaleFactor(UIScreen.main.scale)
                ]
            )
        }
        
        clearDynamicSections()

        addGeneralSection(rocket: rocket)
        
        addSection(title: "", parameters: UIComponentsFactory.createLaunchInfoParams(rocket))
        
        addSection(title: String.UI.fuelStage.localized, parameters: UIComponentsFactory.createFirstStageParams(rocket.firstStage))
        
        addSection(title: String.UI.secondStage.localized, parameters: UIComponentsFactory.createSecondStageParams(rocket.secondStage))
        
        addLaunchesButton()
    }

    private func clearDynamicSections() {
        setDynamicSectionsHidden(true)
    }

    private func setDynamicSectionsHidden(_ hidden: Bool) {
        let keepCount = 2
        guard
            contentStackView.arrangedSubviews.count > keepCount
        else {
            return
        }
        for (index, view) in contentStackView.arrangedSubviews.enumerated() {
            view.isHidden = index >= keepCount ? hidden : false
        }
    }
    
    private func addGeneralSection(rocket: Rocket) {
        let height = viewModel.formattedLengthValue(
            rocket.height.meters,
            for: .height,
            fractionDigits: 1
        )
        let diameter = viewModel.formattedLengthValue(
            rocket.diameter.meters,
            for: .diameter,
            fractionDigits: 1
        )
        let mass = viewModel.formattedMassValue(rocket.mass.kg, for: .mass)
        let payload = viewModel.formattedPayloadValue(rocket.payloadWeights?.first?.kg, for: .payload)
        
        let parameters = UIComponentsFactory.createGeneralParams(height.value, diameter.value, mass.value, payload.value)
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 16
        horizontalStack.distribution = .fill
        
        // add стек
        for parameter in parameters {
            let parameterView = buildCircularParameterView(name: parameter.0, value: parameter.1)
            setupCircularParameterConstraints(parameterView)
            horizontalStack.addArrangedSubview(parameterView)
        }
        
        scrollView.addSubview(horizontalStack)
        
        // Констрейнты для скроллвью - 3 подставил / 2 не подошло
        scrollView.snp.makeConstraints { $0.height.equalTo(Theme.Size.circularParameter + Theme.Spacing.small * 3) }
        
        // Констрейнты для стека внутри скроллвью
        horizontalStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Theme.Spacing.default)
            $0.height.equalTo(Theme.Size.circularParameter)
        }
        
        contentStackView.addArrangedSubview(scrollView)
    }
    
    private func buildCircularParameterView(name: String, value: String) -> UIView {
        let containerView = UIComponentsFactory.makeCircularParameterContainer()
        
        let valueLabel = UIComponentsFactory.makeCircularValueLabel(text: value)
        let nameLabel = UIComponentsFactory.makeCircularNameLabel(text: name)
        
        containerView.addSubview(valueLabel)
        containerView.addSubview(nameLabel)
        
        return containerView
    }
    
    private func setupCircularParameterConstraints(_ containerView: UIView) {
        guard
            let valueLabel = containerView.subviews.compactMap({ $0 as? UILabel }).first,
            let nameLabel = containerView.subviews.compactMap({ $0 as? UILabel }).last
        else {
            return
        }
        containerView.snp.makeConstraints { $0.width.height.equalTo(Theme.Size.circularParameter) }
        valueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    private func addSection(title: String, parameters: [(String, String)]) {
        let sectionTitle = UIComponentsFactory.makeSectionTitle(text: title)
        contentStackView.addArrangedSubview(sectionTitle)
        
        for (name, value) in parameters {
            let paramStack = UIComponentsFactory.makeParameterStack()
            let nameLabel = UIComponentsFactory.makeNameLabel(text: name)
            let valueLabel = UIComponentsFactory.makeValueLabel(text: value)
            
            paramStack.addArrangedSubview(nameLabel)
            paramStack.addArrangedSubview(valueLabel)
            contentStackView.addArrangedSubview(paramStack)
        }
        
        contentStackView.addArrangedSubview(UIComponentsFactory.makeSeparatorView())
    }
    
    private func addLaunchesButton() {
        let launchButton = UIComponentsFactory.makeLaunchButton()
        launchButton.addTarget(self, action: #selector(showLaunches), for: .touchUpInside)
        contentStackView.addArrangedSubview(launchButton)
    }
    
    @objc private func showLaunches() {
        guard
            let rocketId = viewModel.rocket.value?.id
        else {
            return
        }
        onShowLaunches?(rocketId)
    }
    
    @objc private func settingsButtonTapped() {
        onShowSettings?()
    }
}

extension RocketDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let visibleHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let insetBottom = scrollView.contentInset.bottom
        let threshold: CGFloat = 20
        guard
            contentHeight > 0
        else {
            return
        }
        let isAtBottom = offsetY + visibleHeight >= contentHeight + insetBottom - threshold
        onPageControlVisibilityChange?(isAtBottom)
    }
}
