//
//  LocationManager.swift
//  Time To Go
//
//  Created by Joshua McKinnon on 2/7/2022.
//
// Based on a sample published here: https://www.createwithswift.com/using-the-locationbutton-in-swiftui-for-one-time-location-access/

import Foundation
import CoreLocation
import MapKit

/*
 Representation a geofence
 */
struct GeofenceLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name : String
    let radius : Double
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var locationForMap: CLLocationCoordinate2D?
    @Published var regionForMap = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.71610, longitude: 150.32797),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @Published var homeLocation = CLLocationCoordinate2D(latitude: -33.71609, longitude: 150.32800)
    @Published var geofences = [GeofenceLocation]()
    private var currentUserLocation = CLLocation()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func requestAlwaysAuthorization(){
        locationManager.requestAlwaysAuthorization()
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentUserLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization Changed")
    }
    
    func removeGeofences() {
        self.geofences.removeAll()
    }
    
    func setGeofenceForCurrentUserLocation() {
        self.setGeofenceFor(location: self.currentUserLocation.coordinate)
    }
    
    private func setGeofenceFor(location: CLLocationCoordinate2D) {
        let geofenceLocation: GeofenceLocation = GeofenceLocation(coordinate: location, name: "Home", radius: 150.0)
        self.geofences.removeAll()
        self.geofences.append(geofenceLocation)
    }
    
    func centreOnCurrentUserLocation() {
        DispatchQueue.main.async {
            self.locationForMap = self.currentUserLocation.coordinate
            self.regionForMap = MKCoordinateRegion(
                center: self.currentUserLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print (error)
    }
}
