//
//  CurrentWeather.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import Foundation

struct CurrentWeather {
    var cityName: String
    var countryName: String
    var temperature: Double
    var pressure: Int
    var cloudiness: Int
    var rain: Double
    var windSpeed: Double
    var windDeg: Int
    var icon: String
    var main: String
    var date: Int
    
    init(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        countryName = currentWeatherData.sys.country
        temperature = currentWeatherData.main.temp
        pressure = currentWeatherData.main.pressure
        cloudiness = currentWeatherData.clouds.all
        main = currentWeatherData.weather[0].main
        
        if currentWeatherData.rain != nil {
            rain = currentWeatherData.rain!.rain1h
        } else {
            rain = 0
        }
        
        windSpeed = currentWeatherData.wind.speed
        windDeg = currentWeatherData.wind.deg
        icon = currentWeatherData.weather[0].icon
        date = currentWeatherData.dt
    }
    
    init(){
        cityName = "London"
        countryName = "UK"
        temperature = 290
        pressure = 1019
        cloudiness = 57
        rain = 1.0
        windSpeed = 20
        windDeg = 145
        icon = "01d"
        main = "Sunny"
        date = 1560350645
    }
}
