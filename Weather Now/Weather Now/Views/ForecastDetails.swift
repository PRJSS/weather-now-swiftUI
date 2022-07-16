//
//  ForecastDetails.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import SwiftUI


struct ForecastDetails: View {
        var cloudness: String
        var windSpeed: String
        var precipitation: String
    
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Image(systemName: "smoke.fill")
                Text(cloudness)
            }
            VStack {
                Image(systemName: "wind")
                Text(windSpeed)
            }
            VStack {
                Image(systemName: "cloud.heavyrain.fill")
                Text(precipitation)
            }
        }
    }
}

struct ForecastDetails_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetails(cloudness: "56 %", windSpeed: "15 km/h", precipitation: "58 %")
    }
}
