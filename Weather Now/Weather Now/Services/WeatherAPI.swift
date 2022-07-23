//
//  WeatherAPI.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation
import CoreLocation

final class WeatherAPI {
    private static let networkManager = NetworkManager()
    func getForecastWeather(latitude lat: Double, longitude lon: Double) async -> ForecastWeatherData? {
        await WeatherAPI.networkManager.fetchWeather(latitude: lat, longitude: lon, requestType: .forecast) as? ForecastWeatherData
    }
    func getCurrentWeather(latitude lat: Double, longitude lon: Double) async -> CurrentWeatherData? {
        await WeatherAPI.networkManager.fetchWeather(latitude: lat, longitude: lon, requestType: .weather) as? CurrentWeatherData
    }
}
