//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var compassButton: UIButton!
    var defaultLocationName: String?
    var defaultLocationFlag: Bool?
    @IBAction func compassArrowPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: searchTextField.text ?? "Manado")
        (searchTextField.placeholder, searchTextField.text) = (searchTextField.text, "")
//        conditionImageView.image = UIImage(systemName: weatherModel.conditionName ?? "arrow.triangle.2.circlepath.icloud")
    }
}

//MARK: - WeatherProtocolDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherModel: WeatherModel) {
        conditionImageView.image = UIImage(systemName: weatherModel.conditionName ?? "arrow.triangle.2.circlepath.icloud")
        print(weatherModel)
        defaultLocationName = defaultLocationFlag ?? false ? weatherModel.cityName : defaultLocationName
        if defaultLocationName?.lowercased() == weatherModel.cityName.lowercased() {
            compassButton.setBackgroundImage(UIImage(systemName:"location.north.fill"), for: .normal)
        } else {
            compassButton.setBackgroundImage(UIImage(systemName:"location"), for: .normal)
        }
        temperatureLabel.text = weatherModel.temperatureString
        cityLabel.text = weatherModel.cityName
        defaultLocationFlag = nil
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - LocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()
//        let (latitude, longitude) = (manager.location?.coordinate.latitude, manager.location?.coordinate.longitude)
//        weatherManager.fetchWeather(lat: latitude ?? 0, lon: longitude ?? 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("CLLocationArray", locations)
        let (latitude, longitude) = (manager.location?.coordinate.latitude, manager.location?.coordinate.longitude)
        weatherManager.fetchWeather(lat: latitude ?? 0, lon: longitude ?? 0)
        defaultLocationFlag = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }

}
