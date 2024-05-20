//
//  WeatherProtocol.swift
//  Clima
//
//  Created by Gery Josua Sumual on 18/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherModel: WeatherModel)
    func didFailWithError(_ error: Error)
}
