//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import SwiftUI

struct ForecastView: View {
    var manager = NetworkManager()
    
    var body: some View {
        Button("Press") {
            print("Hello")
            downloadWeather()
        }
    }
    
    func downloadWeather() {
        manager.fetchForecastWeather(latitude: 30.214, longitude: 50.134)
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

