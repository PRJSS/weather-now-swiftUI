//
//  ForecastWeather.swift
//  Weather Now
//
//  Created by Бернат Данила on 15.07.2022.
//

import Foundation

class ForecastWeather: NSObject {
    var cityName: String
    var days: [WeatherDay]

    init(forecastWeatherData: ForecastWeatherData) {
        cityName = forecastWeatherData.city.name
        days = []
        days.append(WeatherDay(weather3h: Weather3H(weather3Hdata: forecastWeatherData.list[0])))
        
        var i = 1
        while i < forecastWeatherData.list.count {
            let weather3h = Weather3H(weather3Hdata: forecastWeatherData.list[i])
            if isFromOneDay(dt1: days[days.count - 1].Weather3HList[0].date, dt2: weather3h.date) {
                days[days.count - 1].Weather3HList.append(weather3h)
            } else {
                days.append(WeatherDay(weather3h: weather3h))
            }
            i += 1
        }
    }
    
    override init() {
        self.cityName = "Not Found"
        self.days = [WeatherDay]()
    }
}

struct WeatherDay {
    var dayName: String
    var Weather3HList: [Weather3H]
    
    init(weather3h: Weather3H) {
        dayName = dateToDayName(dt: weather3h.date)
        
        Weather3HList = []
        Weather3HList.append(weather3h)
    }
}


struct Weather3H {
    var date: Int
    var time: String
    var main: String
    var temp: String
    var icon: String
    
    init(weather3Hdata: ForecastWeatherData.List) {
        date = weather3Hdata.dt
        time = dateToTime(dt: weather3Hdata.dt)
        main = weather3Hdata.weather[0].main
        temp = "\(Int(weather3Hdata.main.temp - 273.15))ºC"
        icon = iconFormatter(image: weather3Hdata.weather[0].icon)
    }
}

fileprivate func dateToDayName (dt: Int) -> String {
    let timeResult = Double(dt)
    let date = Date(timeIntervalSince1970: timeResult)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE" //Set date style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

fileprivate func dateToTime (dt: Int) -> String {
    let timeResult = Double(dt)
    let date = Date(timeIntervalSince1970: timeResult)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm" //Set time style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}

fileprivate func isFromOneDay (dt1: Int, dt2: Int) -> Bool {
    let date1 = Date(timeIntervalSince1970: Double(dt1))
    let date2 = Date(timeIntervalSince1970:  Double(dt2))
    
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}

fileprivate func iconFormatter (image: String) -> String {
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

