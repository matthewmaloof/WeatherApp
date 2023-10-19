//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Matthew Maloof on 10/19/23.
//

import Foundation

enum TemperatureUnit {
    case celsius
    case fahrenheit
}

class WeatherViewModel {
    
    private var weatherService: WeatherServiceProtocol
    private var currentTemperatureUnit: TemperatureUnit = .celsius

    private var weatherModels: [WeatherResponse] = []
    private var filteredWeatherModels: [WeatherResponse] = []

    var reloadTable: (() -> ())?
    
    init(weatherService: WeatherServiceProtocol = NetworkService()) {
        self.weatherService = weatherService
    }
    
    func filterCities(by query: String) {
            if query.isEmpty {
                filteredWeatherModels = weatherModels
            } else {
                filteredWeatherModels = weatherModels.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            reloadTable?()
        }
    
    func fetchWeatherData(cities: [String], completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()

        for city in cities {
            dispatchGroup.enter()

            weatherService.fetchWeather(for: city) { [weak self] (weather, error) in
                if let weather = weather {
                    DispatchQueue.main.async {
                        self?.weatherModels.append(weather)
                    }
                    print("Weather data added: \(weather)")
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.reloadTable?()
            completion?()
        }
    }

    
    
    func numberOfRows() -> Int {
        return weatherModels.count
    }
    
    func weather(at index: Int) -> WeatherResponse {
        return weatherModels[index]
    }
    
    func filterByTemperature() {
        weatherModels.sort { $0.main.temp < $1.main.temp }
        reloadTable?()
    }
    
    func toggleTemperatureUnit() {
        switch currentTemperatureUnit {
        case .celsius:
            // Convert all temperatures to Fahrenheit
            convertAllTemperatures(to: .fahrenheit)
            currentTemperatureUnit = .fahrenheit

        case .fahrenheit:
            // Convert all temperatures to Celsius
            convertAllTemperatures(to: .celsius)
            currentTemperatureUnit = .celsius
        }
        // Notify the UI to refresh its data
        reloadTable?()
    }
    private func convertAllTemperatures(to unit: TemperatureUnit) {
        for (index, var model) in weatherModels.enumerated() {
            if unit == .fahrenheit {
                model.main.temp = convertToFahrenheit(model.main.temp)
                model.main.tempMin = model.main.tempMin.map(convertToFahrenheit)
                model.main.tempMax = model.main.tempMax.map(convertToFahrenheit)
            } else {
                model.main.temp = convertToCelsius(model.main.temp)
                model.main.tempMin = model.main.tempMin.map(convertToCelsius)
                model.main.tempMax = model.main.tempMax.map(convertToCelsius)
            }
            weatherModels[index] = model
        }
    }

    private func convertToCelsius(_ tempInFahrenheit: Double) -> Double {
        return (tempInFahrenheit - 32) * 5 / 9
    }

    private func convertToFahrenheit(_ tempInCelsius: Double) -> Double {
        return (tempInCelsius * 9 / 5) + 32
    }
    

    
}
