//
//  Extension to View.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}