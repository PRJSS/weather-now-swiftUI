//
//  ForecastViewModel.swift
//  Weather Now
//
//  Created by Бернат Данила on 14.07.2022.
//

import Foundation

class ForecastViewModel: ObservableObject {
    @Published var forecastWeather: ForecastWeather

    private var locationManager = LocationManager()
    private var weatherAPI = WeatherAPI()
    @Published private var locationData: LocationData?


    func updateWeather() async {
        await updateLocation()
        if self.locationData != nil {
            if let forecastWeather = await weatherAPI.getWeather(latitude: self.locationData!.latitude!, longitude: self.locationData!.longitude!) {
                DispatchQueue.main.async {
                    self.forecastWeather = forecastWeather
                }
            } else {
                print("weatherAPI returns nil")
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

    init() {
        self.forecastWeather = ForecastWeather()
    }
}
