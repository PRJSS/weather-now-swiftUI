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
        return await WeatherAPI.networkManager.fetchForecastWeather(latitude: lat, longitude: lon)
    }
    
    func getCurrentWeather(latitude lat: Double, longitude lon: Double) async -> CurrentWeather? {
        return await WeatherAPI.networkManager.fetchCurrentWeather(latitude: lat, longitude: lon)
    }
    
}


struct NetworkManager {
    
    func fetchForecastWeather(latitude lat: Double, longitude lon: Double) async -> ForecastWeather? {
        guard  let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(ForecastWeatherData.self, from: data) {
                return ForecastWeather(forecastWeatherData: decodedResponse)
            }
        } catch {
        }
        return nil
    }
    
    func fetchCurrentWeather(latitude lat: Double, longitude lon: Double) async -> CurrentWeather? {
        guard  let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                return CurrentWeather(currentWeatherData: decodedResponse)
            }
        } catch {
        }
        return nil
    }
}


