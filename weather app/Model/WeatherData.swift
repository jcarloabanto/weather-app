//
//  WeatherData.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import Foundation

struct WeatherDataArray: Codable {
    let list: [WeatherData]
}

struct WeatherData: Codable {
    let name: String
    let id: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let feels_like: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
    let main: String
    let icon: String
}
