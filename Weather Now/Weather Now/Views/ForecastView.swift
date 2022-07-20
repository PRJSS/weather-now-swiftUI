//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 17.07.2022.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var forecastWeatherViewModel: ForecastWeatherViewModel
    @ObservedObject var currentWeatherViewModel: CurrentWeatherViewModel
    @State var selectedRow: UUID?

    var body: some View {
        List(forecastWeatherViewModel.forecastWeather.days, id: \.dayName) { day in
            if day.dayName == "Current" {
                HStack {
                    Spacer()
                    CurrentWeatherView(viewModel: currentWeatherViewModel)
                    Spacer()
                }
            } else {
                Section(header: Text(day.dayName)) {
                    ForEach(day.weather3HList) { hour in
                        ForecastRow(icon: hour.icon, time: hour.time, weather: hour.main, temperature: hour.temp)
                            .onTapGesture {
                                withAnimation {
                                    if self.selectedRow == hour.id {
                                        self.selectedRow = nil
                                    } else {
                                        self.selectedRow = hour.id
                                    }
                                }
                            }
                        if self.selectedRow == hour.id {
                            HStack {
                                Spacer()
                                ForecastDetailsView(cloudness: hour.cloudness, windSpeed: hour.windSpeed, precipitation: hour.precipitation)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
