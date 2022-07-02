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
//    @Published var 
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
        
        DispatchQueue.main.async {
            self.locationForMap = location.coordinate
            self.regionForMap = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization Changed")
    }
    
    func setGeofenceFor(location: CLLocationCoordinate2D) {
        let geofenceLocation: GeofenceLocation = GeofenceLocation(coordinate: location, name: "Home", radius: 150.0)
        self.geofences.removeAll()
        self.geofences.append(geofenceLocation)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print (error)
    }
}
