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
    @State var isNetworkErrorCatched = false
    @State var isLocationErrorCatched = false
    @State var errorText: String = ""
    @State var viewToShow: ViewToShow = .loading
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationView {
            mainView
                .navigationTitle(forecastWeatherViewModel.cityName)
                .navigationBarTitleDisplayMode(.large)
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
        viewToShow = .loading
        isLocationErrorCatched = false
        isNetworkErrorCatched = false
        errorText = ""
        do {
            try await forecastWeatherViewModel.updateForecast()
            try await currentWeatherViewModel.updateWeather()
        } catch LocationError.notFoundLocation {
            isLocationErrorCatched = true
        } catch NetworkError.networkError {
            isNetworkErrorCatched = true
        } catch {
        }
        if isLocationErrorCatched || isNetworkErrorCatched {
            if isLocationErrorCatched { errorText.count == 0 ? (errorText += "location") : (errorText += " and location") }
            if isNetworkErrorCatched { errorText.count == 0 ? (errorText += "internet connection") : (errorText += " and internet connection") }
            viewToShow = .error
        } else {
            viewToShow = .weather
        }
    }

    @ViewBuilder
    var mainView: some View {
        switch viewToShow {
        case .loading:
            ProgressView("Looking for your forecast...")
        case .weather:
            ForecastView(forecastWeatherViewModel: forecastWeatherViewModel,
                         currentWeatherViewModel: currentWeatherViewModel)
        case .error:
            VStack(spacing: 30) {
                Text("Something wrong with your \(errorText)").foregroundColor(Color("secondary"))
                Button("Refresh") {
                    Task {
                        await updateForecastAndWeather()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("green"))
            }
        }
    }
}

enum ViewToShow {
    case loading
    case weather
    case error
}
