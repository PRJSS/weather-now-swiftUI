//
//  ForecastViewModel.swift
//  Weather Now
//
//  Created by Бернат Данила on 14.07.2022.
//

import Foundation

class ForecastWeatherViewModel: ObservableObject {
    @Published var forecastWeather: ForecastWeather
    @Published private var locationData: LocationData?
    
    private var locationManager = LocationManager()
    private var weatherAPI = WeatherAPI()
    
    init() {
        self.forecastWeather = ForecastWeather()
    }

    func updateForecast() async {
        await updateLocation()
        if self.locationData?.longitude != nil {
            if let forecastWeather = await weatherAPI.getForecastWeather(latitude: self.locationData!.latitude!, longitude: self.locationData!.longitude!) {
                forecastWeather.days.insert(WeatherDay(dayName: "Current"), at: 0)
                DispatchQueue.main.async {
                    self.forecastWeather = forecastWeather
                }
            } else {
                print("weatherAPI returns nil while downloading forecast")
            }
        } else {
            print("location is nil")
        }
    }
    
    private func updateLocation() async {
        locationManager.manager.requestLocation()
        let location = LocationData(latitude: locationManager.manager.location?.coordinate.latitude, longitude: locationManager.manager.location?.coordinate.longitude)
        self.locationData = location
    }
}
