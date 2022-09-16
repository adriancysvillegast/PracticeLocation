//
//  ViewController.swift
//  LocationNames
//
//  Created by Adriancys Jesus Villegas Toro on 5/8/22.
//

import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController {

    //MARK: - properties
    private var map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(map)
        
        LocationManager.share.getLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.addLocationPin(with: location)
            }
        }
    }

    //MARK: - setupView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    //MARK: - getLocation
    
    func addLocationPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.7,
                                                                longitudeDelta: 0.7)),
                      animated: true)
        map.addAnnotation(pin)
        
        LocationManager.share.getLocationName(with: location) { [weak self] locationName in
            self?.title = locationName
        }
    }
}

