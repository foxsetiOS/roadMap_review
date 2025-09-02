import UIKit

final class UIComponentsFactory {
    
    // Создает горизонтальный стек для параметров
    static func makeParameterStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }
    
    // Создает вертикальный стек для секций
    static func makeSectionStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }
    
    // Создает лейбл для названия параметра
    static func makeNameLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.LabGrotesqueFont(style: .regular, size: .medium)
        label.textColor = Theme.Color.secondColorText
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }
    
    // Создает лейбл для значения параметра
    static func makeValueLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.LabGrotesqueFont(style: .bold, size: .medium)
        label.textColor = Theme.Color.colorText
        label.textAlignment = .right
        return label
    }
    
    // Создает заголовок секции
    static func makeSectionTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = Theme.Color.colorText
        return label
    }
    
    // Создает лейбл для кругового параметра (значение)
    static func makeCircularValueLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .bold, size: .medium)
        label.textColor = Theme.Color.colorText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = text
        return label
    }
    
    // Создает лейбл для кругового параметра (название)
    static func makeCircularNameLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .bold, size: .regular)
        label.textColor = Theme.Color.secondColorText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    /// Создает кнопку для просмотра запусков
    static func makeLaunchButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(String.UI.viewLaunches.localized, for: .normal)
        button.titleLabel?.font = UIFont.LabGrotesqueFont(style: .regular, size: .medium)
        button.backgroundColor = Theme.Color.colorCollection
        button.layer.cornerRadius = 12
        button.setTitleColor(Theme.Color.colorText, for: .normal)
        button.snp.makeConstraints { $0.height.equalTo(50) }
        return button
    }
    
    // Создает разделитель между секциями
    static func makeSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Theme.Color.colorCollection
        separator.snp.makeConstraints { $0.height.equalTo(1) }
        return separator
    }
    
    // Создает контейнер для кругового параметра
    static func makeCircularParameterContainer() -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 32
        container.backgroundColor = Theme.Color.colorCollection
        return container
    }
    
    // Создает и настраивает ScrollView для круговых параметров
    static func makeCircularParametersScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
}

extension UIComponentsFactory {
    
    static func createLaunchInfoParams(_ rocket: Rocket) -> [(String, String)] {
        var params: [(String, String)] = []
        
        if let firstFlight = rocket.firstFlight,
           let formattedDate = DateFormatting.formatFirstFlight(firstFlight) {
            params.append((String.LocalizationKey.firstFlight.localized, formattedDate))
        }
        
        params.append((String.LocalizationKey.country.localized, Localized.localizedCountry(rocket.country)))
        
        if let cost = rocket.costPerLaunch, cost > 0,
           let formattedCost = FormatCurrency.formatCurrency(cost) {
            params.append((String.LocalizationKey.launchCost.localized, formattedCost))
        }
        
        return params
    }
    
    static func createFirstStageParams(_ stage: FirstStage?) -> [(String, String)] {
        var params: [(String, String)] = []
        
        if let engines = stage?.engines, engines > 0 {
            params.append((String.LocalizationKey.enginesCount.localized, "\(engines)"))
        }
        
        if let fuelAmount = stage?.fuelAmountTons, fuelAmount > 0 {
            params.append((String.LocalizationKey.fuelAmount.localized, "\(fuelAmount) \(String.LocalizationKey.tons.localized)"))
        }
        
        if let burnTime = stage?.burnTimeSec, burnTime > 0 {
            params.append((String.LocalizationKey.burnTime.localized, "\(burnTime) \(String.LocalizationKey.sec.localized)"))
        }
        
        return params
    }
    
    static func createSecondStageParams(_ stage: SecondStage?) -> [(String, String)] {
        var params: [(String, String)] = []
        
        if let engines = stage?.engines, engines > 0 {
            params.append((String.LocalizationKey.enginesCount.localized, "\(engines)"))
        }
        
        if let fuelAmount = stage?.fuelAmountTons, fuelAmount > 0 {
            params.append((String.LocalizationKey.fuelAmount.localized, "\(fuelAmount) \(String.LocalizationKey.ton.localized)"))
        }
        
        if let burnTime = stage?.burnTimeSec, burnTime > 0 {
            params.append((String.LocalizationKey.burnTime.localized, "\(burnTime) \(String.LocalizationKey.sec.localized)"))
        }
        
        return params
    }
    
    static func createGeneralParams(_ height: String?, _ diameter: String?, _ mass: String?, _ payload: String?) -> [(String, String)] {
        var params: [(String, String)] = []
        
        if let heightNumber = height {
            params.append((String.LocalizationKey.height.localized + ", \(heightNumber)", heightNumber))
        }
        
        if let diameterNumber = diameter {
            params.append((String.LocalizationKey.diameter.localized + ", \(diameterNumber)", diameterNumber))
        }
        
        if let massNumber = mass {
            params.append((String.LocalizationKey.mass.localized + ", \(massNumber)", massNumber))
        }
        
        if let payloadNumber = payload {
            params.append((String.LocalizationKey.payload.localized + ", \(payloadNumber)", payloadNumber))
        }
        
        return params
    }
}
