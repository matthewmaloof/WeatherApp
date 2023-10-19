//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Matthew Maloof on 10/19/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private var weatherView: WeatherView!
    var weatherViewModel = WeatherViewModel()
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var citySearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self

        setupUI()
        setupBindings()
        
        weatherViewModel.fetchWeatherData(cities: ["London", "New York"]) {
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            }
        weatherTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        
        weatherViewModel.reloadTable = { [weak self] in
                self?.weatherTableView.reloadData()
            }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
        weatherTableView.refreshControl = refreshControl

    }
    @objc private func fetchWeatherData() {
        weatherViewModel.fetchWeatherData(cities: ["London", "New York"]) {
            DispatchQueue.main.async {
                self.weatherTableView.refreshControl?.endRefreshing()
                self.weatherTableView.reloadData()
            }
        }
    }

    
    private func setupUI() {
        weatherView = WeatherView()
        view.addSubview(weatherView)
        
        weatherView.tableView.delegate = self
        weatherView.tableView.dataSource = self
        
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: Constants.weatherCellIdentifier)
    }
    
    @IBAction func temperatureUnitChanged(_ sender: Any) {
        weatherViewModel.toggleTemperatureUnit()
        weatherTableView.reloadData()
    }
    private func setupBindings() {
        weatherViewModel = WeatherViewModel()
        weatherViewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherView.tableView.reloadData()
            }
        }
    }


}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let weather = weatherViewModel.weather(at: indexPath.row)
        cell.textLabel?.text = "\(weather.name): \(weather.main.temp)"
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedWeather = weatherViewModel.weather(at: indexPath.row)
//        let detailVC = WeatherDetailViewController(weather: selectedWeather)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }


}


extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Here you can trigger your ViewModel to filter cities based on `searchText`
        weatherViewModel.filterCities(by: searchText)
    }
}
