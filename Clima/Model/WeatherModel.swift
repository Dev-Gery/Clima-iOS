//
//  WeatherModel.swift
//  Clima
//
//  Created by Gery Josua Sumual on 17/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var conditionName: String? {
        switch conditionId {
        case 200...202, 210...212, 221, 230...232:
            return "cloud.bolt.rain"
        case 300...302, 310...314, 321:
            return "cloud.rain"
        case 500...504, 511, 520...522, 531:
            return "cloud.heavyrain"
        case 600...602, 611...616, 620...622:
            return "cloud.snow"
        case 701, 711, 721, 731, 741, 751, 761, 762, 771, 781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803, 804:
            return "smoke"
        default:
            return "\(conditionId) is unknown or not listed"
        }
    }

}
