import Foundation

struct Setting: Equatable, Codable {
    let type: SettingType
    var unit: Unit
}
