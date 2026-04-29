//
//  LocationManager.swift
//  Maply
//
//  Created by Wilder Moreno on 25/04/26.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine

final class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocation?
    @Published var region: MKCoordinateRegion
    @Published var cameraPosition: MapCameraPosition
    @Published var locationErrorMessage: String = ""
    
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
        updateLocationErrorMessage()
    }
    
    func requestWhenInUseAuthorizationIfNeeded() {
        guard authorizationStatus == .notDetermined else { return }
        manager.requestWhenInUseAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocationIfAuthorized() {
        guard isLocationAuthorized else { return }
        manager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func refreshAuthorizationStatus() {
        authorizationStatus = manager.authorizationStatus
        updateLocationErrorMessage()
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
    
    private func updateLocationErrorMessage() {
        switch authorizationStatus {
        case .notDetermined:
            locationErrorMessage = "Maply necesita acceso a tu ubicación para centrar el mapa y guardar lugares cercanos."
        case .restricted:
            locationErrorMessage = "El acceso a la ubicación está restringido en este dispositivo."
        case .denied:
            locationErrorMessage = "Has denegado el acceso a la ubicación. Puedes habilitarlo desde Ajustes."
        case .authorizedWhenInUse, .authorizedAlways:
            locationErrorMessage = ""
        @unknown default:
            locationErrorMessage = "No se pudo determinar el estado del permiso de ubicación."
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        updateLocationErrorMessage()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted, .denied:
            stopUpdatingLocation()
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
        locationErrorMessage = "No se pudo obtener tu ubicación actual."
        print("Error obteniendo ubicación: \(error.localizedDescription)")
    }
}
