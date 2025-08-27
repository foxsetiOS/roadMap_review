import Foundation
import UIKit

extension String {
    
    enum LocalizationKey {
        static let launches = "launches"
        static let settings = "settings"
        static let close = "close"
        static let firstFlight = "first_flight"
        static let country = "country"
        static let launchCost = "launch_cost"
        static let height = "height"
        static let diameter = "diameter"
        static let mass = "mass"
        static let payload = "payload"
        static let firstStage = "first_stage"
        static let secondStage = "second_stage"
        static let enginesCount = "engines_count"
        static let fuelAmount = "fuel_amount"
        static let burnTime = "burn_time"
        static let tons = "tons"
        static let ton = "ton"
        static let sec = "sec"
        static let meters = "meters"
        static let feet = "feet"
        static let kilograms = "kilograms"
        static let pounds = "pounds"
        static let countryMarshallIslands = "country.marshall_islands"
        static let countryUsa = "country.usa"
        static let deff = "deff"
        static let noDate = "no_date"
    }

    enum ErrorMessage {
        static let errorId = "Ошибка"
        static let errorName = "Ошибка загрузки"
        static let errorRocket = "ошибка загрузки Ракеты"
        static let errorDate = "Ошибка"
    }

    enum UI {
        static let letsGo = "Поехали 🚀"
        static let spacexLogo = "SpaceXlogo"
        static let viewLaunches = "view_launches"
        static let fuelStage = "fuel_stage"
        static let secondStage = "second_stage"
    }
    
    enum FatalError {
        static let initCoder = "init(coder:) has not been implemented"
        static let windowAppDelegate = "упал window в AppDelegate"
        static let containerDIContainer = "упал container. проверить setupDependencies() метод."
        static let cellDequeue = "упал смотри метод cellForRowAt SettingSegmentCell"
    }
    
    // API
    enum API {
        static let baseUrl = "https://api.spacexdata.com/v4"
        static let rocketsEndpoint = "/rockets"
        static let launchesEndpoint = "/launches"
    }
    
    enum CellIdentifier {
        static let settingSegmentCell = "SettingSegmentCell"
    }
    
    enum Format {
        static let decimalFormat = "%.1f"
        static let fallbackDash = "—"
    }
}

extension String {
    
    enum AssetName {
        static let spacex = "spacex"
        static let falcon9 = "falcon9"
        static let falconHeavy = "falconHeavy"
        static let nasa = "nasa"
        static let rocketFail = "rocketFail"
        static let rocketRide = "rocketRide"
        static let setting = "Setting"
    }
}

extension String {
    
    enum ColorName {
        static let colorCollection = "colorCollection"
        static let colorText = "colorText"
        static let colorView = "colorView"
        static let secondColorText = "secondColorText"
    }
}
