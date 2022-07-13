//
//  ForecastWeatherData.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation

// MARK: - Welcome
struct ForecastWeatherData: Codable {
    let cod: String
        let message, cnt: Int
        let list: [List]
        let city: City

    // MARK: - City
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population, timezone, sunrise, sunset: Int
    }

    // MARK: - Coord
    struct Coord: Codable {
        let lat, lon: Double
    }

    // MARK: - List
    struct List: Codable {
        let dt: Int
        let main: MainClass
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let sys: Sys
        let dt_txt: String
    }

    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int
    }

    // MARK: - MainClass
    struct MainClass: Codable {
        let temp, feels_like, temp_min, temp_max: Double
        let pressure, sea_level, grnd_level, humidity: Int
        let temp_kf: Double
    }

    // MARK: - Rain
    struct Rain: Codable {
        let the3H: Double

        enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let pod: String
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
}
