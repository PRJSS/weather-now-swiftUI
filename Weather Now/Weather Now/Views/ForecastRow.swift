//
//  ForecastRow.swift
//  Weather Now
//
//  Created by Бернат Данила on 15.07.2022.
//

import SwiftUI

struct ForecastRow: View {
    var icon: String
    var time: String
    var weather: String
    var temperature: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: icon).font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(time)
                Text(weather)
            }
            Spacer()
            Text(temperature).font(.system(size: 50))
        }
    }
}
