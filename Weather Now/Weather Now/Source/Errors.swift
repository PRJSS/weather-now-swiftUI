//
//  Errors.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import Foundation

enum LocationError: Error {
    case notFoundLocation
}

enum NetworkError: Error {
    case networkError
}
