//
//  LocationManager.swift
//  Maply
//
//  Created by Wilder Moreno on 25/04/26.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit
import Combine

final class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocation?
    @Published var region: MKCoordinateRegion
    @Published var cameraPosition: MapCameraPosition
    
    override init() {
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -8.11599, longitude: -79.02998),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        
        self.authorizationStatus = manager.authorizationStatus
        self.region = initialRegion
        self.cameraPosition = .region(initialRegion)
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func recenterOnUser() {
        guard let location = currentLocation else { return }
        
        let updatedRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        region = updatedRegion
        cameraPosition = .region(updatedRegion)
    }
    
    var authorizationStatusText: String {
        switch authorizationStatus {
        case .notDetermined:
            return "No solicitado"
        case .restricted:
            return "Restringido"
        case .denied:
            return "Denegado"
        case .authorizedWhenInUse:
            return "Permitido al usar la app"
        case .authorizedAlways:
            return "Permitido siempre"
        @unknown default:
            return "Desconocido"
        }
    }

    var isLocationAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    var canRequestLocationPermission: Bool {
        authorizationStatus == .notDetermined
    }

    var shouldShowOpenSettings: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        currentLocation = location
        
        let updatedRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        region = updatedRegion
        cameraPosition = .region(updatedRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo ubicación: \(error.localizedDescription)")
    }
}
