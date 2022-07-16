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
    @State var selectedRow: UUID?
    
    var body: some View {
        VStack{
            NavigationView {
                
                ZStack {
                    List(viewModel.forecastWeather.days, id: \.dayName) { day in
                        Section(header: Text(day.dayName)) {
                            ForEach(day.weather3HList) { hour in
                                
                                ForecastRow(icon: hour.icon, time: hour.time, weather: hour.main, temperature: hour.temp).onTapGesture {
                                    withAnimation {
                                        self.selectedRow = hour.id
                                    }
                                }
                                if (self.selectedRow == hour.id) {
                                    HStack {
                                        Spacer()
                                        ForecastDetails(cloudness: hour.cloudness, windSpeed: hour.windSpeed, precipitation: hour.precipitation)
                                        Spacer()
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                    }.listStyle(InsetGroupedListStyle())
                    
                    ProgressView("Looking for your forecast...").hidden(!isLoading)
                }
                
                .navigationTitle(viewModel.forecastWeather.cityName)
                .navigationBarTitleDisplayMode(.large)
            }
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



