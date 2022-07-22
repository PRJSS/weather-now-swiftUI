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
struct NetworkManager {
    enum RequestType: String {
        case forecast
        case weather
    }
    func fetchWeather(latitude lat: Double, longitude lon: Double, requestType: RequestType) async -> Any? {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/\(requestType.rawValue)?lat=\(lat)&lon=\(lon)&appid=\(Constants.apiKey)") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            switch requestType {
            case .forecast:
                if let decodedResponse = try? JSONDecoder().decode(ForecastWeatherData.self, from: data) {
                    return decodedResponse
                }
            case .weather:
                if let decodedResponse = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                    return decodedResponse
                }
            }
        } catch { }
        return nil
    }
}
