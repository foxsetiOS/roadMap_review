protocol SettingsStorage {
    
    func save(settings: [Setting])
    func load() -> [Setting]
}
