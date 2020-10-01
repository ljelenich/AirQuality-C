//
//  DVMCityDetailViewController.swift
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class DVMCityDetailViewController: UIViewController {

    // MARK: - Properties
    var country: String?
    var state: String?
    var city: String?
        
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let city = city, let state = state, let country = country else { return }
        DVMCityAirQualityController.fetchData(forCity: city, state: state, country: country) { (city) in
            if let details = city {
                self.updateViews(with: details)
            }
        }
    }

    // MARK: - Class Methods
    func updateViews(with details: DVMCityAirQuality) {
        print(details.city, details.state, details.country)
        DispatchQueue.main.async {
            self.cityNameLabel.text = details.city
            self.stateLabel.text = (details.state)
            self.countryLabel.text = details.country
            self.aqiLabel.text = "Air Quality Index: \(details.pollution.airQualityIndex)"
            self.windSpeedLabel.text = "Wind Speed: \(details.weather.windSpeed) mph "
            self.temperatureLabel.text = "Temperature: \(details.weather.temperature)°"
            self.humidityLabel.text = "Humidity: \(details.weather.humidity)%"
        }
    }
}
