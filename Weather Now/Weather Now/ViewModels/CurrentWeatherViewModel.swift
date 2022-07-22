//
//  CurrentWeatherViewModel.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import Foundation
import CoreLocation

class CurrentWeatherViewModel: NSObject, ObservableObject, canGetLocation {

    @Published var location: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        locationManager.stopUpdatingLocation()
    }

    @Published var currentWeatherData: CurrentWeatherData?
    @Published private var locationData: LocationData?
    private var weatherAPI = WeatherAPI()
    var mainCondition: String {
        return currentWeatherData?.weather[0].main ?? "Sunny"
    }
    var locationInfo: String {
        return "\(currentWeatherData?.name ?? "London"),\(currentWeatherData?.sys.country ?? "UK")"
    }
    var temperature: String {
        return "\(Int((currentWeatherData?.main.temp ?? 290) - 273.15))ºC"
    }
    var pressure: String {
        return "\(Int(currentWeatherData?.main.pressure ?? 1019)) hPa"
    }
    var cloudiness: String {
        return "\(Int(currentWeatherData?.clouds.all ?? 57))%"
    }
    var rain: String {
        guard let rainData = currentWeatherData?.rain else { return "0 mm" }
        return "\(rainData.rain1h) mm"
    }
    var windSpeed: String {
        return "\(Int(currentWeatherData?.wind.speed ?? 0)) km/h"
    }
    var windDeg: String {
        switch Int(currentWeatherData?.wind.deg ?? 145) {
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
        let timeResult = Double(currentWeatherData?.dt ?? 1560350645)
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return "\(localDate)"
    }
    var image: String {
        let image = currentWeatherData?.weather[0].icon ?? "01d"
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
            if let currentWeatherData = await weatherAPI.getCurrentWeather(latitude: self.locationData!.latitude!, longitude: self.locationData!.longitude!) {
                DispatchQueue.main.async {
                    self.currentWeatherData = currentWeatherData
                }
            } else {
                throw NetworkError.networkError
            }
        } else {
            throw LocationError.notFoundLocation
        }
    }

    private func updateLocation() async {
        locationManager.requestLocation()
        let location = LocationData(latitude: locationManager.location?.coordinate.latitude,
                                    longitude: locationManager.location?.coordinate.longitude)
        self.locationData = location
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        }
    override init() {
        super.init()
        locationManager.delegate = self
    }
    init(currentWeatherData: CurrentWeatherData) {
        self.currentWeatherData = currentWeatherData
    }
}
