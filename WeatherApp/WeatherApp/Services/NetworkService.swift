//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Matthew Maloof on 10/19/23.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?, Error?) -> Void)
}


class NetworkService: WeatherServiceProtocol {
    
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        let apiKey = "9a886f58ffc36fd81c83212ab386e366"
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("Network Request Made")
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                print("Decoding successful: \(weather)")

                completion(weather, nil)
            } catch {
                print("Decoding failed: \(error)")

                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
