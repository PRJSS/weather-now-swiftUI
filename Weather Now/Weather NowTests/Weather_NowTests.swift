//
//  Weather_NowTests.swift
//  Weather NowTests
//
//  Created by Бернат Данила on 13.07.2022.
//

import XCTest
@testable import Weather_Now

class Weather_NowTests: XCTestCase {

    func fetchWeather() async {
        let api = WeatherAPI()
        let weather = await api.getCurrentWeather(latitude: 10.0, longitude: 10.0)
        XCTAssert(weather != nil)
    }

}
