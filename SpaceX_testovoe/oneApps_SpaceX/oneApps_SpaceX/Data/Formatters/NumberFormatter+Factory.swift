import Foundation

extension NumberFormatter {
    /// Общий фабричный метод для десятичных чисел
    static func decimalFormatter(fractionDigits: Int, grouping: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.usesGroupingSeparator = grouping
        return formatter
    }
    
    /// Целые числа с разделителями групп
    static let integerWithGrouping: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }()
}


