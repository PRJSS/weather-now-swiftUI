//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var viewModel = ForecastViewModel()
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            List(viewModel.forecastWeather.days, id: \.dayName) { item in
                Section(header: Text(item.dayName)) {
                    ForEach(item.weather3HList) { item in
                        ForecastRow(icon: item.icon, time: item.time, weather: item.main, temperature: item.temp)
                    }
                }
            }
            ProgressView("Looking for your forecast...").hidden(!isLoading)
        }
                .onAppear {
                    Task {
                        await updateForecast()
                    }
                }
    }
    
    func updateForecast() async {
        isLoading = true
        await viewModel.updateWeather()
        print("weather updated")
        isLoading = false
        
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
            .previewInterfaceOrientation(.portrait)
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

