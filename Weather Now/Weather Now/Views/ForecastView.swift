//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var forecastWeatherViewModel = ForecastWeatherViewModel()
    @ObservedObject var currentWeatherViewModel = CurrentWeatherViewModel()
    @State var isLoading = false
    @State var isNetworkErrorCatched = false
    @State var isLocationErrorCatched = false
    @State var selectedRow: UUID?
    @State var errorText: String = ""
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                if (self.selectedRow == hour.id) {
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
                .hidden(isLoading)
                ProgressView("Looking for your forecast...").hidden(!isLoading)
                
                VStack(spacing: 30) {
                    Text("Something wrong with your \(errorText)").foregroundColor(.secondary)
                    Button("Refresh") {
                        Task {
                            await updateForecastAndWeather()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }.hidden(!(isLocationErrorCatched || isNetworkErrorCatched))
                
            }
            .navigationTitle(forecastWeatherViewModel.forecastWeather.cityName)
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            Task {
                await updateForecastAndWeather()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    await updateForecastAndWeather()
                }
            }
        }
    }
    
    func updateForecastAndWeather() async {
        isLocationErrorCatched = false
        isNetworkErrorCatched = false
        errorText = ""
        isLoading = true
        
        do {
            try await forecastWeatherViewModel.updateForecast()
            try await currentWeatherViewModel.updateWeather()
        } catch locationError.notFoundLocation {
            isLocationErrorCatched = true
        } catch networkError.networkError {
            isNetworkErrorCatched = true
        } catch {
        }
        
        if (isLocationErrorCatched || isNetworkErrorCatched) {
            if isLocationErrorCatched { errorText.count == 0 ? (errorText += "location") : (errorText += " and location") }
            if isNetworkErrorCatched { errorText.count == 0 ? (errorText += "internet connection") : (errorText += " and internet connection") }
        }
        
        isLoading = false
    }
}



