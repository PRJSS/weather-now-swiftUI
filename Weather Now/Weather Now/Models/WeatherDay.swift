//
//  WeatherDay.swift
//  Weather Now
//
//  Created by Бернат Данила on 22.07.2022.
//

import Foundation

struct WeatherDay {
    var dayName: String
    var weather3HList: [Weather3H]
    init(weather3h: Weather3H) {
        dayName = dateToDayName(dt: weather3h.date)
        weather3HList = []
        weather3HList.append(weather3h)
    }
    init (dayName: String) {
        self.dayName = dayName
        self.weather3HList = []
    }
}

func dateToDayName (dt: Int) -> String {
    let timeResult = Double(dt)
    let date = Date(timeIntervalSince1970: timeResult)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

func dateToTime (dt: Int) -> String {
    let timeResult = Double(dt)
    let date = Date(timeIntervalSince1970: timeResult)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

func iconFormatter (image: String) -> String {
    switch image {
    case "01d":
        return "sun.max"
    case "02d":
        return "cloud.sun"
    case "03d":
        return "cloud"
    case "04d":
        return "smoke"
    case "09d":
        return "cloud.drizzle"
    case "10d":
        return "cloud.sun.rain"
    case "11d":
        return "cloud.bolt.rain"
    case "13d":
        return "snowflake"
    case "50d":
        return "cloud.fog"
    case "01n":
        return "moon"
    case "02n":
        return "cloud.moon"
    case "03n":
        return "cloud"
    case "04n":
        return "smoke"
    case "09n":
        return "cloud.drizzle"
    case "10n":
        return "cloud.moon.rain"
    case "11n":
        return "cloud.bolt.rain"
    case "13n":
        return "snowflake"
    case "50n":
        return "cloud.fog"
    default:
        return "sun.max"
    }
}
