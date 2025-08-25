enum SettingType: String, Codable, CaseIterable {
    
    case height
    case diameter
    case mass
    case payload
    
    var title: String {
        switch self {
        case .height: 
            return "Высота"
        case .diameter: 
            return "Диаметр"
        case .mass: 
            return "Масса"
        case .payload:
            return "Полезная нагрузка"
        }
    }
}
