//
//  WeatherManger.swift
//  Clima
//
//  Created by Gery Josua Sumual on 17/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=933dba770636e9c428931ec9fbd19563&units=metric"
    
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        return performRequest(with: urlString)
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        return performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //create a URL
        if let url = URL(string: urlString) {
            //create a URL session
            let session = URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if error != nil {
                    DispatchQueue.main.async {
                        delegate?.didFailWithError(error!)
                    }
                    return
                }
                
                if let safeData = data {
                    let _ : String! = String(data: safeData, encoding: .utf8)
                    if let weatherModel = parseJSON(safeData) {
                        DispatchQueue.main.sync {
                            delegate?.didUpdateWeather(weatherModel)
                        }
                    }
                }
                //                    print(dataString!)
            })
            //start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weatherModel = WeatherModel(cityName: name, conditionId: id, temperature: Double(temp))
            //            print(weatherModel.temperatureString, weatherModel.conditionName)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
    
