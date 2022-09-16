//
//  LocationManager.swift
//  LocationNames
//
//  Created by Adriancys Jesus Villegas Toro on 5/8/22.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    //MARK: - properties
    static let share = LocationManager()
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    //MARK: - Get Location
    
    public func getLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    public func getLocationName(with location: CLLocation,
                                completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placeMark, error in
            /**placemark is name **/
            guard let place = placeMark?.first, error == nil else {
                completion(nil)
                return
            }
            
//            print(place)
            var name = ""
            
            if let locality = place.locality {
                name += locality
            }
            
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            
            completion(name)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
//        print("LONGITUDE: \(location.coordinate.longitude), LONGITUDE:  \(location.coordinate.latitude)")
        manager.stopUpdatingLocation()
    }
}
