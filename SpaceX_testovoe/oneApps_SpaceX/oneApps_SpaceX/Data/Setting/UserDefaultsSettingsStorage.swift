import Foundation
import Alamofire

final class UserDefaultsSettingsStorage: SettingsStorage {
    private enum Keys {
        static let settings = "spacex_app_settings"
    }
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save(settings: [Setting]) {
        do {
            let data = try encoder.encode(settings)
            userDefaults.set(data, forKey: Keys.settings)
        } catch {
            print("Settings save error: \(error)")
        }
    }
    
    func load() -> [Setting] {
        guard let data = userDefaults.data(forKey: Keys.settings) else {
            return []
        }
        
        do {
            return try decoder.decode([Setting].self, from: data)
        } catch {
            print("Settings load error: \(error)")
            return []
        }
    }
}
