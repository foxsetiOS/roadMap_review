import Foundation

enum Unit: String, CaseIterable, Codable {
    case meters = "m"
    case feet = "ft"
    case kilograms = "kg"
    case pounds = "lb"
    
    var symbol: String {
        rawValue
    }
}
