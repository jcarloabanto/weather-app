//
//  APIService.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import Foundation
import CoreLocation

protocol APIServiceDelegate {
    func didUpdateWeather(_ weatherNetworkManager: APIService, weather: [WeatherViewModel])
    func didFailWithError(error: Error)
}

struct APIService {
    let weatherURL = "https://api.openweathermap.org/data/2.5"
    let apiKey = "def1f26d9ff7e8aba18b677f7e267b67"
    var delegate: APIServiceDelegate?
    
    func fetchWeatherByCity(cityName: String) {
        let urlString = "\(weatherURL)/weather?units=metric&appid=\(apiKey)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherDefault() {
        if UserDefaults.standard.stringArray(forKey: "defaultId") == nil {
            //set default Sydney, Brisbane, Melbourne
            UserDefaults.standard.setValue(["4163971","2147714","2174003"], forKey: "defaultId")
        }
        let defaultWeatherIds = UserDefaults.standard.stringArray(forKey: "defaultId")
        let ids = defaultWeatherIds?.joined(separator: ",")
      
        let urlString = "\(weatherURL)/group?units=metric&appid=\(apiKey)&id=\(ids!)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherByLocation(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let urlString = "\(weatherURL)/weather?units=metric&appid=\(apiKey)&lat=\(lat)&lon=\(long)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let unwrappedData = data {
                    if urlString.contains("group") {
                        if let weatherArray = self.parseJSONArray(unwrappedData) {
                            self.delegate?.didUpdateWeather(self, weather: weatherArray)
                        }
                    } else {
                        if let weather = self.parseJSON(unwrappedData) {
                            self.delegate?.didUpdateWeather(self, weather: [weather])
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherViewModel? {
       let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherViewModel(weatherData: decodedData)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONArray(_ data: Data) -> [WeatherViewModel]? {
        let decoder = JSONDecoder()
        do {
            var weatherArray = [WeatherViewModel]()
            let decodedData = try decoder.decode(WeatherDataArray.self, from: data)
            print(decodedData.list)
            for eachWeather in decodedData.list {
                let weather = WeatherViewModel(weatherData: eachWeather)
                weatherArray.append(weather)
            }
            return weatherArray
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
