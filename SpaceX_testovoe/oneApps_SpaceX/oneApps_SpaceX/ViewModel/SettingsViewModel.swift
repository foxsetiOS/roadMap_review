final class SettingsViewModel {
    
    private let settingsManager: SettingsManagerProtocol
    let settings = Observable<[Setting]>([])
    let settingsChanged = Observable<Void>(())
    
    init(settingsManager: SettingsManagerProtocol = SettingsManager.shared) {
        self.settingsManager = settingsManager
        settings.value = settingsManager.settings
        
        settingsManager.settingsChanged.bind { [weak self] in
            self?.settings.value = self?.settingsManager.settings ?? []
            self?.settingsChanged.value = ()
        }
    }
    
    func updateSetting(for type: SettingType, unit: Unit) {
        settingsManager.setUnit(unit, for: type)
    }
    
    func unitOptions(for type: SettingType) -> [Unit] {
        switch type {
        case .height, .diameter:
            return [.meters, .feet]
        case .mass, .payload:
            return [.kilograms, .pounds]
        }
    }
}
