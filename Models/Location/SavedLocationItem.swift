//
//  SavedLocationItem.swift
//  Maply
//
//  Created by Wilder Moreno on 26/04/26.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class SavedLocationItem {
    var id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var colorHex: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        colorHex: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.colorHex = colorHex
        self.createdAt = createdAt
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
