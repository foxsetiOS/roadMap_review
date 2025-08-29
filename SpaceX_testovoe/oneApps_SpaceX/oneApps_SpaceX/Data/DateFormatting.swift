import Foundation

enum DateFormatting {
    
    // Отдельно парсинг
    static func parseFirstFlightDate(_ dateString: String?) -> Date? {
        guard
            let dateString
        else {
            return nil
        }
        
        // Статический форматтер для парсинга
        struct Parser {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
        }
        
        return Parser.formatter.date(from: dateString)
    }
    
    static func parseLaunchDate(_ dateString: String?) -> Date? {
        guard
            let dateString
        else {
            return nil
        }
        
        let isoWithFraction = ISO8601DateFormatter()
        isoWithFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoWithFraction.date(from: dateString) { return date }

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: dateString) { return date }
        
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ"
        ]
        
        for format in dateFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = format
            if let parsed = dateFormatter.date(from: dateString) { return parsed }
        }
        
        return nil
    }
    
    // Отдельно форматирование
    static func formatDateToRussian(_ date: Date) -> String {
        struct Formatter {
            static let russianFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.timeZone = .current
                formatter.dateFormat = "d MMMM, yyyy"
                return formatter
            }()
        }
        
        return Formatter.russianFormatter.string(from: date)
    }
    
    static func formatLaunchDate(_ dateString: String?) -> String? {
        guard
            let date = parseLaunchDate(dateString)
        else {
            return nil
        }
        
        struct Formatter {
            static let launchFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.timeZone = .current
                formatter.dateFormat = "d MMMM yyyy"
                return formatter
            }()
        }
        
        return Formatter.launchFormatter.string(from: date)
    }
    
    static func formatFirstFlight(_ dateString: String?) -> String? {
        guard
            let date = parseFirstFlightDate(dateString)
        else {
            return nil
        }
        return formatDateToRussian(date)
    }
}
