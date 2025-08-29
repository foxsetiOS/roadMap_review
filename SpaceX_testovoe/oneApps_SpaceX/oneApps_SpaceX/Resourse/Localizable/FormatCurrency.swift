import Foundation

struct FormatCurrency {
    
    private static let millionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesSignificantDigits = false
        return formatter
    }()

    static func formatCurrency(_ valueUsd: Double) -> String? {
        let valueInMillions = valueUsd / 1_000_000
        let formattedNumber = millionFormatter.string(from: NSNumber(value: valueInMillions))
        return formattedNumber.map { "$\($0)M" }
    }
}

