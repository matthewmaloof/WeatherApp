//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Matthew Maloof on 10/19/23.
//

import XCTest
@testable import WeatherApp

class MockWeatherService: WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        let main = Main(temp: 283.15, tempMin: nil, tempMax: nil)
        let weather = Weather(main: "Cloudy", description: "cloudy skies")
        completion(WeatherResponse(name: "London", main: main, weather: [weather]), nil)
    }
}

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    
    override func setUp() {
        super.setUp()
        let mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchWeatherData() {
        let expectation = XCTestExpectation(description: "Fetch weather data")

        viewModel.fetchWeatherData(cities: ["London"]) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)

        XCTAssertGreaterThan(viewModel.numberOfRows(), 0, "Number of rows should be greater than 0 after fetching data.")
    }
}
