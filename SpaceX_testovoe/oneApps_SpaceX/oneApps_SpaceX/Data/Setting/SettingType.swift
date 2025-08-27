enum SettingType: String, Codable, CaseIterable {
    
    case height
    case diameter
    case mass
    case payload
    
    var title: String {
        switch self {
        case .height: 
            return "height".localized
        case .diameter: 
            return "diameter".localized
        case .mass:
            return "mass".localized
        case .payload:
            return "payload".localized
        }
    }
}
