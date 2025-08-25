enum Localized {
    static func localizedCountry(_ englishName: String) -> String {
        let map: [String: String] = [
            "Republic of the Marshall Islands": "country.marshall_islands".localized,
            "United States": "country.usa".localized
        ]
        return map[englishName] ?? englishName
    }
}
