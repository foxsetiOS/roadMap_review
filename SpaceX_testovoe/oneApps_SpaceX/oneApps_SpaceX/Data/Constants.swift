import UIKit


enum Constants {
    static let defaultInset: CGFloat = Theme.Spacing.default
    static let cornerRadius: CGFloat = Theme.Radius.block
    static let buttonHeight: CGFloat = Theme.Size.buttonHeight
    static let pageControlHeight: CGFloat = Theme.Size.pageControlHeight
    static let headerImageHeight: CGFloat = Theme.Size.headerImageHeight
    static let factorMetersFeet: CGFloat = 3.28084
    static let factorPounds: CGFloat = 2.20462
    
}

enum Theme {
    enum Color {
        static let colorText: UIColor = .colorText
        static let secondColorText: UIColor = .secondColorText
        static let colorCollection: UIColor = .colorCollection
        static let colorView: UIColor = .colorView
        static let colorFailer: UIColor = .red
        static let colorSuccess: UIColor = .green
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let `default`: CGFloat = 16
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
    }
    
    enum Radius {
        static let block: CGFloat = 12
        static let card: CGFloat = 16
        static let circularParameter: CGFloat = 48 
    }
    
    enum Size {
        static let buttonHeight: CGFloat = 60
        static let pageControlHeight: CGFloat = 30
        static let headerImageHeight: CGFloat = 300
        static let circularParameter: CGFloat = 96
    }
}

