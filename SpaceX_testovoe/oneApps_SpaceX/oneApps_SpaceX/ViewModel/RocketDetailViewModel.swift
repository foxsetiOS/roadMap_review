import Foundation

final class RocketDetailViewModel {
    
    private let rocketId: String
    private let networkService: NetworkServiceProtocol
    private let settingsManager: SettingsManagerProtocol
    let rocket = Observable<Rocket?>(nil)
    let isLoading = Observable<Bool>(false)
    
    init(
        rocketId: String,
        networkService: NetworkServiceProtocol = NetworkService(),
        settingsManager: SettingsManagerProtocol = SettingsManager.shared
    ) {
        self.rocketId = rocketId
        self.networkService = networkService
        self.settingsManager = settingsManager
        
        settingsManager.settingsChanged.bind { [weak self] in
            if let current = self?.rocket.value {
                self?.rocket.value = current
            }
        }
    }
    
    func loadRocket() {
        isLoading.value = true
        Task { @MainActor in
            do {
                let rockets = try await networkService.fetchRockets()
                if let rocket = rockets.first(where: { $0.id == rocketId }) {
                    self.rocket.value = rocket
                }
            } catch {
                print("Ошибка Загрузки Ракеты: \(error)")
            }
            isLoading.value = false
        }
    }
    
    func convertLength(_ valueInMeters: Double?, for type: SettingType) -> String? {
        guard
            let valueInMeters = valueInMeters
        else {
            return nil
        }
        let unit = settingsManager.getUnit(for: type)
        switch unit {
        case .feet:
            return "\(valueInMeters * Constants.factorMetersFeet) \(unit.symbol)"
        default:
            return "\(valueInMeters) \(unit.symbol)"
        }
    }
    
    func convertMass(_ valueInKilograms: Double, for type: SettingType) -> String {
        let unit = settingsManager.getUnit(for: type)
        switch unit {
        case .pounds:
            return "\(valueInKilograms * Constants.factorPounds) \(unit.symbol)"
        default:
            return "\(valueInKilograms) \(unit.symbol)"
        }
    }
    
    func formattedLengthValue(
        _ valueInMeters: Double?,
        for type: SettingType,
        fractionDigits: Int = 1
    ) -> (value: String?, unit: String?) {
        guard
            let valueInMeters = valueInMeters
        else {
            return (nil, nil)
        }
        let unit = settingsManager.getUnit(for: type)

        let converted: Double
        switch unit {
        case .feet:
            converted = valueInMeters * Constants.factorMetersFeet
        default:
            converted = valueInMeters
        }

        let formatter = NumberFormatter.decimalFormatter(fractionDigits: fractionDigits, grouping: false)
        let valueString = formatter.string(from: NSNumber(value: converted)) ?? String(format: "%.\(fractionDigits)f", converted)
        return (valueString, unit.symbol)
    }

    func formattedMassValue(
        _ valueInKilograms: Double?,
        for type: SettingType
    ) -> (value: String?, unit: String?) {
        guard
            let valueInKilograms = valueInKilograms
        else {
            return (nil, nil)
        }
        let unit = settingsManager.getUnit(for: type)
        let converted: Double
        switch unit {
        case .pounds:
            converted = valueInKilograms * Constants.factorPounds
        default:
            converted = valueInKilograms
        }

        let valueString = NumberFormatter.integerWithGrouping.string(from: NSNumber(value: converted)) ?? String(Int(converted))
        return (valueString, unit.symbol)
    }

    func formattedPayloadValue(
        _ valueInKilograms: Double?,
        for type: SettingType
    ) -> (value: String?, unit: String?) {
        guard
            let valueInKilograms = valueInKilograms
        else {
            return (nil, nil)
        }
        return formattedMassValue(valueInKilograms, for: type)
    }
}
