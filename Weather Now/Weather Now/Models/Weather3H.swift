//
//  Weather3H.swift
//  Weather Now
//
//  Created by Бернат Данила on 22.07.2022.
//

import Foundation

struct Weather3H: Identifiable {
    var id: UUID
    var date: Int
    var time: String
    var main: String
    var temp: String
    var icon: String
    var cloudness: String
    var windSpeed: String
    var precipitation: String
    init(weather3Hdata: ForecastWeatherData.List) {
        date = weather3Hdata.dt
        time = dateToTime(dt: weather3Hdata.dt)
        main = weather3Hdata.weather[0].main
        temp = "\(Int(weather3Hdata.main.temp - 273.15))ºC"
        icon = iconFormatter(image: weather3Hdata.weather[0].icon)
        id = UUID()
        cloudness = "\(weather3Hdata.clouds.all) %"
        windSpeed = "\(Int(weather3Hdata.wind.speed)) km/h"
        precipitation = "\(Int(weather3Hdata.pop * 100)) %"
    }
}
