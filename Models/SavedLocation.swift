//
//  SavedLocation.swift
//  Maply
//
//  Created by Wilder Moreno on 25/04/26.
//

import Foundation
import CoreLocation
import SwiftUI

struct SavedLocation: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let color: Color
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
