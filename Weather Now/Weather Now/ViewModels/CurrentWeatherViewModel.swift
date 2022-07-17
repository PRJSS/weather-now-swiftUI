//
//  CurrentWeatherViewModel.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import Foundation

class CurrentWeatherViewModel: ObservableObject {
    
    @Published var currentWeather: CurrentWeather
    @Published private var locationData: LocationData?
    
    private var locationManager = LocationManager()
    private var weatherAPI = WeatherAPI()
    
    var mainCondition: String {
        return currentWeather.main
    }
    
    var location: String {
        return "\(currentWeather.cityName), \(currentWeather.countryName)"
    }
    
    var temperature: String {
        
        return "\(Int(currentWeather.temperature - 273.15))ºC"
    }
    
    var pressure: String {
        return "\(Int(currentWeather.pressure)) hPa"
    }
    
    var cloudiness: String {
        return "\(Int(currentWeather.cloudiness))%"
    }
    
    var rain: String {
        return "\(currentWeather.rain) mm"
    }
    
    var windSpeed: String {
        return "\(Int(currentWeather.windSpeed)) km/h"
    }
    
    var windDeg: String {
        switch Int(currentWeather.windDeg) {
        case 0...11:
            return "N"
        case 350...365:
            return "N"
        case 12...34:
            return "NNE"
        case 35...56:
            return "NE"
        case 57...79:
            return "ENE"
        case 80...101:
            return "E"
        case 102...124:
            return "ESE"
        case 125...146:
            return "SE"
        case 147...169:
            return "SSE"
        case 170...191:
            return "S"
        case 192...214:
            return "SSW"
        case 215...236:
            return "SW"
        case 237...259:
            return "WSW"
        case 260...281:
            return "W"
        case 282...304:
            return "WNW"
        case 305...326:
            return "NW"
        case 327...349:
            return "NNW"
        default:
            return "NaN"
        }
    }
    
    var date: String {
        let timeResult = Double(currentWeather.date)
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return "\(localDate)"
    }
    
    var image: String {
        let image = currentWeather.icon
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
    
    func updateWeather() async throws {
        await updateLocation()
        if self.locationData?.longitude != nil {
            if let currentWeather = await weatherAPI.getCurrentWeather(latitude: self.locationData!.latitude!, longitude: self.locationData!.longitude!) {
                DispatchQueue.main.async {
                    self.currentWeather = currentWeather
                }
            } else {
                print("2")
                throw networkError.networkError
            }
        } else {
            throw locationError.notFoundLocation
        }
    }
    
    private func updateLocation() async {
        locationManager.manager.requestLocation()
        let location = LocationData(latitude: locationManager.manager.location?.coordinate.latitude, longitude: locationManager.manager.location?.coordinate.longitude)
        self.locationData = location
    }
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    init() {
        self.currentWeather = CurrentWeather()
    }
}


