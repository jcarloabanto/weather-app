//
//  WeatherDetailViewController.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import UIKit
import CoreLocation

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var addStackView: UIStackView!

    //text field
    @IBOutlet weak var searchTextField: UITextField!
    //image view
    @IBOutlet weak var conditionImage: UIImageView!
    //labels
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var apiService = APIService()
    var weatherViewModel: WeatherViewModel?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpView()
    }
    
    func initializeDelegates() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchTextField.delegate = self
        apiService.delegate = self
    }
    
    func setUpView() {
        DispatchQueue.main.async {
            if let weather = self.weatherViewModel {
                self.addStackView.alpha = 0
                self.cityLabel.text = weather.cityName
                self.tempLabel.text = weather.temp
                self.minMaxLabel.text = weather.tempMinMax
                self.humidityLabel.text = weather.humidity
                self.feelsLikeLabel.text = weather.feelsLike
                self.conditionImage.image = weather.conditionImage
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var defaultWeatherIds = UserDefaults.standard.stringArray(forKey: "defaultId")
        defaultWeatherIds!.append(self.weatherViewModel!.cityId)
        UserDefaults.standard.setValue(defaultWeatherIds!, forKey: "defaultId")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addingWeatherModel"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - API Service Delegate

extension WeatherDetailViewController: APIServiceDelegate {
    
    func didUpdateWeather(_ weatherNetworkManager: APIService, weather: [WeatherViewModel]) {
        self.weatherViewModel = weather[0]
        
        DispatchQueue.main.async {
            self.setUpView()
            self.addButton.alpha = 1
        }
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error Encountered", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Text Field Delegate

extension WeatherDetailViewController: UITextFieldDelegate {
    
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
        
        if let city = searchTextField.text {
            apiService.fetchWeatherByCity(cityName: city)
        }
    
        searchTextField.text = ""
    }
}


//MARK: - Location Manager Delegate

extension WeatherDetailViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            apiService.fetchWeatherByLocation(lat: lat, long: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
