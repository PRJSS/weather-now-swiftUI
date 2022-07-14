//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import SwiftUI

struct ForecastView: View {
    var api = WeatherAPI()
    
    var body: some View {
        Button("Press") {
            print("Hello")
            downloadWeather()
            
            
        }
    }
    
    func downloadWeather()  {
        WeatherAPI.getWeather { forecastWeatherData in
            print(forecastWeatherData.city.country)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

