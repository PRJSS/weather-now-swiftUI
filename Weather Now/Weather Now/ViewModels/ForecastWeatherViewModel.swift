//
//  ForecastViewModel.swift
//  Weather Now
//
//  Created by Бернат Данила on 14.07.2022.
//

import Foundation
import CoreLocation

class ForecastWeatherViewModel: NSObject, ObservableObject, canGetLocation {
    @Published var location: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    @Published var forecastWeatherData: ForecastWeatherData?
    @Published private var locationData: LocationData?
    private var weatherAPI = WeatherAPI()
    var cityName: String {
        return forecastWeatherData?.city.name ?? "Not Found"
    }
    var days: [WeatherDay] = []

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        locationManager.stopUpdatingLocation()
    }

    func updateForecast() async throws {
        await updateLocation()
        if self.locationData?.longitude != nil {
            if let forecastWeatherData = await weatherAPI.getForecastWeather(latitude: self.locationData!.latitude!,
                                                                             longitude: self.locationData!.longitude!) {
                setDays(forecastWeatherData: forecastWeatherData)
                DispatchQueue.main.async {
                    self.forecastWeatherData = forecastWeatherData
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
        let location = LocationData(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
        self.locationData = location
    }

    private func setDays(forecastWeatherData: ForecastWeatherData) {
        var days: [WeatherDay] = []
        days.insert(WeatherDay(dayName: "Current"), at: 0)
        days.append(WeatherDay(weather3h: Weather3H(weather3Hdata: forecastWeatherData.list[0])))
        var i = 1
        while i < forecastWeatherData.list.count {
            let weather3h = Weather3H(weather3Hdata: forecastWeatherData.list[i])
            if isFromOneDay(dt1: days[days.count - 1].weather3HList[0].date, dt2: weather3h.date) {
                days[days.count - 1].weather3HList.append(weather3h)
            } else {
                days.append(WeatherDay(weather3h: weather3h))
            }
            i += 1
        }
        self.days = days
    }

    private func isFromOneDay (dt1: Int, dt2: Int) -> Bool {
        let date1 = Date(timeIntervalSince1970: Double(dt1))
        let date2 = Date(timeIntervalSince1970: Double(dt2))
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        }

    override init() {
        super.init()
        locationManager.delegate = self
    }
}
