//
//  Errors.swift
//  Weather Now
//
//  Created by Бернат Данила on 16.07.2022.
//

import Foundation

enum locationError: Error {
    case notFoundLocation
}

enum networkError: Error {
    case networkError
}
