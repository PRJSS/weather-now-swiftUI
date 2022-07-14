//
//  NetworManager.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation

struct NetworkManager {
        
    var forecastWeatherOnComplition: ((ForecastWeatherData) -> Void)?
    
    func fetchForecastWeather(latitude lat: Double, longitude lon: Double, completionBlock: @escaping (ForecastWeatherData) -> Void) {
        guard  let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {return}
        print(url)
        let session: URLSession = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let forecastWeatherData = self.parseForecastWeatherJSON(withData: data){
                    print("2. get forecastWeather")
                    completionBlock(forecastWeatherData)
                }
            }
        }
        task.resume()
    }
    
    func parseForecastWeatherJSON(withData data: Data) -> ForecastWeatherData? {
        let decoder = JSONDecoder()
        do {
            let forecastWeatherData = try decoder.decode(ForecastWeatherData.self, from: data)
            return forecastWeatherData
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
