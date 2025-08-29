import UIKit
import SnapKit
import Kingfisher

final class RocketDetailViewController: UIViewController {
    private let viewModel: RocketDetailViewModel
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
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
        contentStackView.axis = .vertical
        contentStackView.spacing = 25
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
        
        addSection(title: "", parameters: {
            var parameters: [(String, String)] = []
            
            if let firstFlight = rocket.firstFlight,
               let formattedDate = DateFormatting.formatFirstFlight(firstFlight) {
                parameters.append((String.LocalizationKey.firstFlight.localized, formattedDate))
            }

            parameters.append((String.LocalizationKey.country.localized, Localized.localizedCountry(rocket.country)))

            if let cost = rocket.costPerLaunch, cost > 0,
               let formattedCost = FormatCurrency.formatCurrency(cost) {
                parameters.append((String.LocalizationKey.launchCost.localized, formattedCost))
            }
            
            return parameters
        }())
        
        addSection(title: String.UI.fuelStage.localized, parameters: {
            var parameters: [(String, String)] = []
            
            if let engines = rocket.firstStage?.engines, engines > 0 {
                parameters.append((String.LocalizationKey.enginesCount.localized, "\(engines)"))
            }

            if let fuelAmount = rocket.firstStage?.fuelAmountTons, fuelAmount > 0 {
                parameters.append((String.LocalizationKey.fuelAmount.localized, "\(fuelAmount) " + String.LocalizationKey.tons.localized))
            }

            if let burnTime = rocket.firstStage?.burnTimeSec, burnTime > 0 {
                parameters.append((String.LocalizationKey.burnTime.localized, "\(burnTime) " + String.LocalizationKey.sec.localized))
            }
            
            return parameters
        }())
        
        addSection(title: String.UI.secondStage.localized, parameters: {
            var parameters: [(String, String)] = []
            
            if let engines = rocket.secondStage?.engines, engines > 0 {
                parameters.append((String.LocalizationKey.enginesCount.localized, "\(engines)"))
            }
            
            if let fuelAmount = rocket.secondStage?.fuelAmountTons, fuelAmount > 0 {
                parameters.append((String.LocalizationKey.fuelAmount.localized, "\(fuelAmount) " + String.LocalizationKey.ton.localized))
            }
 
            if let burnTime = rocket.secondStage?.burnTimeSec, burnTime > 0 {
                parameters.append((String.LocalizationKey.burnTime.localized, "\(burnTime) " + String.LocalizationKey.sec.localized))
            }
            
            return parameters
        }())
        
        addLaunchesButton()
    }

    private func clearDynamicSections() {
        setDynamicSectionsHidden(true)
    }

    private func setDynamicSectionsHidden(_ hidden: Bool) {
        let keepCount = 2 
        guard contentStackView.arrangedSubviews.count > keepCount else { return }
        for (index, view) in contentStackView.arrangedSubviews.enumerated() {
            view.isHidden = index >= keepCount ? hidden : false
        }
    }
    
    private func addGeneralSection(rocket: Rocket) {
        // Готовим форматированные пары для карточек: отдельно value и unit в подписи
        let height = viewModel.formattedLengthValue(rocket.height.meters, for: .height, fractionDigits: 1)
        let diameter = viewModel.formattedLengthValue(rocket.diameter.meters, for: .diameter, fractionDigits: 1)
        let mass = viewModel.formattedMassValue(rocket.mass.kg, for: .mass)
        let payloadKg = rocket.payloadWeights?.first?.kg
        let payload = viewModel.formattedPayloadValue(payloadKg, for: .payload)
        
        var parameters: [(String, String)] = []
        
        // Добавляем только если есть данные
        if let heightNumber = height.value {
            parameters.append((String.LocalizationKey.height.localized + ", \(heightNumber)", heightNumber))
        }
        
        if let diameterNumber = diameter.value {
            parameters.append((String.LocalizationKey.diameter.localized + ", \(diameterNumber)", diameterNumber))
        }
        
        if let massNumber = mass.value {
            parameters.append((String.LocalizationKey.mass.localized + ", \(massNumber)", massNumber))
        }
        
        if let payloadNumber = payload.value {
            parameters.append((String.LocalizationKey.payload.localized + ", \(payloadNumber)", payloadNumber))
        }
        
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
        let containerView = UIView()
        containerView.layer.cornerRadius = 32
        containerView.backgroundColor = Theme.Color.colorCollection
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.LabGrotesqueFont(style: .bold, size: .medium)
        valueLabel.textColor = Theme.Color.colorText
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 0
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.8
        valueLabel.text = value
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.LabGrotesqueFont(style: .bold, size: .regular)
        nameLabel.textColor = Theme.Color.secondColorText
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = name
        
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
        let sectionTitle = UILabel()
        sectionTitle.text = title

        sectionTitle.textColor = Theme.Color.colorText
        contentStackView.addArrangedSubview(sectionTitle)
        
        for (name, value) in parameters {
            let paramStack = UIStackView()
            paramStack.axis = .horizontal
            paramStack.distribution = .fill
            paramStack.spacing = 16
            
            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = UIFont.LabGrotesqueFont(style: .regular, size: .medium)
            nameLabel.textColor = Theme.Color.secondColorText
            nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = UIFont.LabGrotesqueFont(style: .bold, size: .medium)
            valueLabel.textColor = Theme.Color.colorText
            valueLabel.textAlignment = .right
            
            paramStack.addArrangedSubview(nameLabel)
            paramStack.addArrangedSubview(valueLabel)
            contentStackView.addArrangedSubview(paramStack)
        }
        
        contentStackView.addArrangedSubview(makeSeparatorView())
    }
    
    private func addLaunchesButton() {
        let launchButton = UIButton(type: .system)
        launchButton.setTitle(String.UI.viewLaunches.localized, for: .normal)
        launchButton.titleLabel?.font = UIFont.LabGrotesqueFont(style: .regular, size: .medium)
        launchButton.backgroundColor = Theme.Color.colorCollection
        launchButton.layer.cornerRadius = 12
        launchButton.setTitleColor(Theme.Color.colorText, for: .normal)
        launchButton.snp.makeConstraints { $0.height.equalTo(50) }
        launchButton.addTarget(self, action: #selector(showLaunches), for: .touchUpInside)
        contentStackView.addArrangedSubview(launchButton)
    }
    
    private func makeSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Theme.Color.colorCollection
        separator.snp.makeConstraints { $0.height.equalTo(1) }
        return separator
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
