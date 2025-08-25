enum Unit: String, Codable, CaseIterable {
    
    case meters = "m"
    case feet = "ft"
    case kilograms = "kg"
    case pounds = "lb"
    
    var symbol: String {
        rawValue
    }
}
