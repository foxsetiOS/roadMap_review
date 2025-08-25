protocol SettingsManagerProtocol {
    
    var settings: [Setting] { get }
    var settingsChanged: Observable<Void> { get }
    func setUnit(_ unit: Unit, for type: SettingType)
    func getUnit(for type: SettingType) -> Unit
}

final class SettingsManager: SettingsManagerProtocol {
    static let shared = SettingsManager()
    
    private let storage: SettingsStorage
    private(set) var settings: [Setting] = [] {
        didSet {
            storage.save(settings: settings)
            settingsChanged.value = ()
        }
    }
    
    let settingsChanged = Observable<Void>(())
    
    init(storage: SettingsStorage = UserDefaultsSettingsStorage()) {
        self.storage = storage
        self.settings = loadOrCreateSettings()
    }
    
    func setUnit(_ unit: Unit, for type: SettingType) {
        if let index = settings.firstIndex(where: { $0.type == type }) {
            settings[index].unit = unit
        } else {
            settings.append(Setting(type: type, unit: unit))
        }
    }
    
    func getUnit(for type: SettingType) -> Unit {
        settings.first { $0.type == type }?.unit ?? defaultUnit(for: type)
    }
    
    private func loadOrCreateSettings() -> [Setting] {
        let storedSettings = storage.load()
        
        if storedSettings.isEmpty {
            return SettingType.allCases.map { type in
                Setting(type: type, unit: defaultUnit(for: type))
            }
        }
        
        return storedSettings
    }
    
    private func defaultUnit(for type: SettingType) -> Unit {
        switch type {
        case .height, .diameter:
            return .meters
        case .mass, .payload:
            return .kilograms
        }
    }
}
