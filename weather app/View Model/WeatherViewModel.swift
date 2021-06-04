//
//  WeatherViewModel.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import Foundation
import UIKit

struct WeatherViewModel {
    
    let cityName: String
    let cityId: String
    let temp: String
    let humidity: String
    let feelsLike: String
    let conditionImage: UIImage
    let tempMinMax: String
    
    init(weatherData: WeatherData) {
        
        self.cityName = weatherData.name
        self.cityId = "\(weatherData.id)"
        self.temp = "\(String(format: "%.1f", weatherData.main.temp)) °C"
        self.tempMinMax = "Temp Min: \(String(format: "%.1f", weatherData.main.temp_min)) °C, Temp Max: \(String(format: "%.1f", weatherData.main.temp_max)) °C"
        self.humidity = "Humidity: \(weatherData.main.humidity)"
        self.feelsLike = "Feels like \(String(format: "%.1f", weatherData.main.feels_like)) °C"
        switch weatherData.weather[0].id {
        case 200...232:
            self.conditionImage = UIImage(systemName: "cloud.bolt") ?? UIImage()
        case 300...321:
            self.conditionImage =  UIImage(systemName: "cloud.drizzle") ?? UIImage()
        case 500...531:
            self.conditionImage =  UIImage(systemName: "cloud.rain") ?? UIImage()
        case 600...622:
            self.conditionImage =  UIImage(systemName: "cloud.snow") ?? UIImage()
        case 701...781:
            self.conditionImage =  UIImage(systemName: "cloud.fog") ?? UIImage()
        case 800:
            self.conditionImage =  UIImage(systemName: "sun.max") ?? UIImage()
        case 801...804:
            self.conditionImage =  UIImage(systemName: "cloud.bolt") ?? UIImage()
        default:
            self.conditionImage =  UIImage(systemName: "cloud") ?? UIImage()
        }
    }
}
