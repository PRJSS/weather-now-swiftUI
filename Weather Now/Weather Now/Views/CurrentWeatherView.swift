//
//  CurrentWeatherView.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var viewModel: CurrentWeatherViewModel
    @State private var isSharePresented: Bool = false
    @State private var shareText: ShareText?
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: viewModel.image).font(.system(size: 90))
                Text(viewModel.location)
                Text("\(viewModel.temperature) | \(viewModel.mainCondition)")
                    .font(.system(size: 25))
            }
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center, spacing: 30) {
                    VStack {
                        Image(systemName: "cloud.hail")
                        Text(viewModel.rain)
                    }
                    VStack {
                        Image(systemName: "drop")
                        Text(viewModel.rain)
                    }
                    VStack {
                        Image(systemName: "speedometer")
                        Text(viewModel.pressure)
                    }
                }
                HStack(alignment: .center, spacing: 30) {
                    VStack {
                        Image(systemName: "wind")
                        Text(viewModel.windSpeed)
                    }
                    VStack {
                        Image(systemName: "safari")
                        Text(viewModel.windDeg)
                    }
                }
                Button("Share") {
                    self.isSharePresented = true
                    let text = "Current weather in \(self.viewModel.location) is: \(self.viewModel.temperature), \(self.viewModel.mainCondition), \(self.viewModel.pressure)."
                    shareText = ShareText(text: text)
                }
                .sheet(item: $shareText) { shareText in
                    ActivityView(text: shareText.text)
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
            }
        }
        .padding()
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(viewModel: CurrentWeatherViewModel(currentWeather: CurrentWeather()))
    }
}
