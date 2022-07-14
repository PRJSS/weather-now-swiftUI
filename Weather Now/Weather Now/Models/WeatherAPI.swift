//
//  WeatherAPI.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation
import CoreLocation

final class WeatherAPI {
    static let shared = WeatherAPI()
    
    static let networkManager = NetworkManager()
    static var locationData = LocationData()
    
    var completionBlock: ((ForecastWeatherData) -> Void)?
    
    static func getWeather(completionBlock: @escaping (ForecastWeatherData) -> Void) {
        if WeatherAPI.locationData.latitude == nil {
            LocationManager.shared.getUserLocation { location in
                WeatherAPI.locationData.latitude = location.coordinate.latitude
                WeatherAPI.locationData.longitude = location.coordinate.longitude
                WeatherAPI.networkManager.fetchForecastWeather(latitude: WeatherAPI.locationData.latitude!, longitude: WeatherAPI.locationData.longitude!) { forecastWeatherData in
                    completionBlock(forecastWeatherData)
                }
                
            }
        } else {
            WeatherAPI.networkManager.fetchForecastWeather(latitude: WeatherAPI.locationData.latitude!, longitude: WeatherAPI.locationData.longitude!) { forecastWeatherData in
                completionBlock(forecastWeatherData)
            }
        }
    }
}



