//
//  canGetLocationProtocol.swift
//  Weather Now
//
//  Created by Бернат Данила on 13.07.2022.
//

import Foundation
import CoreLocation

protocol canGetLocation: CLLocationManagerDelegate {
    var location: CLLocationCoordinate2D? { get set }
    var locationManager: CLLocationManager { get set }
    func requestLocation()
}
