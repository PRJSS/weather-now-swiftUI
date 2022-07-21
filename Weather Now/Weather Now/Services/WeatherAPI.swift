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
    func getForecastWeather(latitude lat: Double, longitude lon: Double) async -> ForecastWeather? {
        guard let forecast = await WeatherAPI.networkManager.fetchWeather(latitude: lat, longitude: lon, requestType: .forecast) as? ForecastWeather else {
            return nil
        }
        return forecast
    }
    func getCurrentWeather(latitude lat: Double, longitude lon: Double) async -> CurrentWeather? {
        guard let current = await WeatherAPI.networkManager.fetchWeather(latitude: lat, longitude: lon, requestType: .current) as? CurrentWeather else {
            return nil
        }
        return current
    }
}

struct NetworkManager {
    enum RequestType {
        case forecast
        case current
    }
    func fetchWeather(latitude lat: Double, longitude lon: Double, requestType: RequestType) async -> Any? {
        switch requestType {
        case .forecast:
            guard  let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(Constants.apiKey)") else { return nil }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(ForecastWeatherData.self, from: data) {
                    return ForecastWeather(forecastWeatherData: decodedResponse)
                }
            } catch { }
            return nil
        case .current:
            guard  let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.apiKey)") else { return nil }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                    return CurrentWeather(currentWeatherData: decodedResponse)
                }
            } catch { }
            return nil
        }
    }
}
