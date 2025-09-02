import UIKit

enum FontSize: CGFloat {
    case small = 12
    case regular = 14
    case medium = 16
    case large = 18
    case title = 24
}

enum LabGrotesqueFont: String {
    case light = "LabGrotesque-Light"
    case regular = "LabGrotesque-Regular"
    case medium = "LabGrotesque-Medium"
    case bold = "LabGrotesque-Bold"
    
    func ofSize(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: self.rawValue,
            size: size
        ) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {
    static func LabGrotesqueFont(
        style: LabGrotesqueFont,
        size: FontSize
    ) -> UIFont {
        return style.ofSize(size.rawValue)
    }
}
