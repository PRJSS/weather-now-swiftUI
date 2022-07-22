//
//  canGetLocationProtocol.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation
import CoreLocation

protocol canGetLocation: CLLocationManagerDelegate {
    var locationManager: CLLocationManager { get set }
    func requestLocation()
}
