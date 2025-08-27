import Foundation

func formatCurrency(_ valueUsd: Double) -> String? {
    
    let formatCurrency = NumberFormatter()
    formatCurrency.numberStyle = .currency
    formatCurrency.usesSignificantDigits = true
    formatCurrency.minimumSignificantDigits = 4
    formatCurrency.maximumFractionDigits = 0
    formatCurrency.currencySymbol = "$ млн"
    return formatCurrency.string(from: NSNumber(value: valueUsd))
}
