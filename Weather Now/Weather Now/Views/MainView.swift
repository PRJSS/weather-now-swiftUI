//
//  ForecastView.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var forecastWeatherViewModel = ForecastWeatherViewModel()
    @ObservedObject var currentWeatherViewModel = CurrentWeatherViewModel()
    @State var isLoading = false
    @State var isForecastHide = false
    @State var isNetworkErrorCatched = false
    @State var isLocationErrorCatched = false
    @State var errorText: String = ""
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            ZStack {
                //HERE
                ForecastView(forecastWeatherViewModel: forecastWeatherViewModel, currentWeatherViewModel: currentWeatherViewModel)
                .hidden(isForecastHide)
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
        isForecastHide = true
        
        do {
            try await forecastWeatherViewModel.updateForecast()
            try await currentWeatherViewModel.updateWeather()
        } catch locationError.notFoundLocation {
            isLocationErrorCatched = true
            isForecastHide = true
        } catch networkError.networkError {
            isNetworkErrorCatched = true
            isForecastHide = true
        } catch {
        }
        
        if (isLocationErrorCatched || isNetworkErrorCatched) {
            if isLocationErrorCatched { errorText.count == 0 ? (errorText += "location") : (errorText += " and location") }
            if isNetworkErrorCatched { errorText.count == 0 ? (errorText += "internet connection") : (errorText += " and internet connection") }
        }
        
        isLoading = false
        
        if !(isNetworkErrorCatched || isLocationErrorCatched) { isForecastHide = false }
    }
}


