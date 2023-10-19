//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Matthew Maloof on 10/19/23.
//

import Foundation

// Represents the top-level JSON object returned by the API
struct WeatherResponse: Decodable {
    var name: String  // City name
    var main: Main  // Main weather data
    var weather: [Weather]  // Additional weather info, usually an array with one element
}

// Represents the 'main' object in the JSON response, containing temperature and related data
struct Main: Decodable {
    var temp: Double  // Current temperature
    var tempMin: Double?  // Minimum temperature
    var tempMax: Double?  // Maximum temperature
}

// Represents the 'weather' object in the JSON response, containing weather conditions like clear sky, rain, etc.
struct Weather: Decodable {
    let main: String  // Main weather condition, e.g., "Clear"
    let description: String  // Description of the weather condition, e.g., "clear sky"
}
