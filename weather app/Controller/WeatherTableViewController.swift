//
//  WeatherTableViewController.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    var apiService = APIService()
    var weatherViewModel = [WeatherViewModel]()
    var selectedWeather: WeatherViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherModel), name: Notification.Name("addingWeatherModel"), object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateWeatherModel), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let vc = segue.destination as! WeatherDetailViewController
            vc.weatherViewModel = selectedWeather
            selectedWeather = nil
        }
    }
    
    @objc func updateWeatherModel() {
        self.apiService.fetchWeatherDefault()
    }
}

//MARK: - Update Data to UI

extension WeatherTableViewController: APIServiceDelegate {
    func didUpdateWeather(_ weatherNetworkManager: APIService, weather: [WeatherViewModel]) {
        for weatherObject in weather {
            weatherViewModel.removeAll { $0.cityName == weatherObject.cityName }
            weatherViewModel.append(weatherObject)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error Encountered", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        tableView.contentInset.top = 50
        tableView.tableFooterView = UIView()
        apiService.delegate = self
        apiService.fetchWeatherDefault()
    }
}


// MARK: - Table view data source

extension WeatherTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.count == 0 ? 1 : weatherViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        if weatherViewModel.count != 0 {
            cell.weatherViewModel = weatherViewModel[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWeather = weatherViewModel[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToDetail", sender: self)
        
    }
}
