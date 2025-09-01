import Foundation

enum DateFormatting {
    
    private struct Formatters {
        // Для парсинга простых дат
        static let simpleParser: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        // Для форматирования в русский формат
        static let russianFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.calendar = Calendar(identifier: .gregorian)
            // ИСПРАВЛЕНО: используем UTC для согласованности
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "d MMMM yyyy"
            return formatter
        }()
        
        // ISO8601 форматтеры (переиспользуемые)
        static let isoWithFraction: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
        
        static let isoStandard: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter
        }()
        
        // ИСПРАВЛЕНО: убрали дублирующие ISO8601 форматы
        static let fallbackParsers: [DateFormatter] = {
            let formats = [
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                "yyyy-MM-dd HH:mm:ss",
                "yyyy/MM/dd HH:mm:ss"
            ]
            
            return formats.map { format in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = format
                return formatter
            }
        }()
    }
    
    // MARK: - Parsing
    static func parseFirstFlightDate(_ dateString: String?) -> Date? {
        guard
            let dateString = dateString?.trimmingCharacters(in: .whitespacesAndNewlines),
              !dateString.isEmpty
        else
        {
            return nil
        }
        return Formatters.simpleParser.date(from: dateString)
    }
    
    static func parseLaunchDate(_ dateString: String?) -> Date? {
        guard
            let dateString = dateString?.trimmingCharacters(in: .whitespacesAndNewlines),
              !dateString.isEmpty
        else
        {
            return nil
        }
        
        if let date = Formatters.isoWithFraction.date(from: dateString) {
            return date
        }
        
        if let date = Formatters.isoStandard.date(from: dateString) {
            return date
        }
        
        // Fallback только для уникальных форматов
        for formatter in Formatters.fallbackParsers {
            if let parsed = formatter.date(from: dateString) {
                return parsed
            }
        }
        
        return nil
    }

    static func formatDateToRussian(_ date: Date) -> String {
        return Formatters.russianFormatter.string(from: date)
    }
    
    static func formatLaunchDate(_ dateString: String?) -> String? {
        guard
            let date = parseLaunchDate(dateString)
        else
        {
            return nil
        }
        return formatDateToRussian(date)
    }
    
    static func formatFirstFlight(_ dateString: String?) -> String? {
        guard
            let date = parseFirstFlightDate(dateString)
        else
        {
            return nil
        }
        return formatDateToRussian(date)
    }
}
