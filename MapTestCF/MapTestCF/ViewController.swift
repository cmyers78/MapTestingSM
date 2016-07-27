//
//  ViewController.swift
//  MapTestCF
//
//  Created by Christopher Myers on 7/27/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var Boxes = [Box]()
    
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 2000
        //self.locationManager.startUpdatingLocation()
        self.findUserLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK : Find user location & boxes
    
    func findUserLocation() {
        
        let status = CLAuthorizationStatus.AuthorizedWhenInUse
        
        if status != .Denied {
            self.mapView.showsUserLocation = true
            self.locationManager.requestLocation()
        }
    }
    
    func findBox() {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "CrossFit"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler {
            (response, error) in
            
            if let response = response {
                for item in response.mapItems {
                    
                    let theBox = Box()
                    
                    if let name = item.name {
                        theBox.boxName = name
                    }
                    
                    if let phone = item.phoneNumber {
                        theBox.boxPhone = phone
                    }
                    
                    //                    if let url = item.url as? String {
                    //                        theBox.boxURL = url
                    //                    }
                    
                    
                    //                    print(item.name)
                    //                    print(item.phoneNumber)
                    //                    print(item.url)
                    if let test = item.placemark.addressDictionary?["FormattedAddressLines"] as? NSArray{
                        if test.count == 3 {
                            
                            theBox.boxAddressStreet = test[0] as! String
                            theBox.boxAddressCSZ = test[1] as! String
                            theBox.boxAddressCountry = test[2] as! String
                            
                        } else {
                            theBox.boxAddressStreet = test[0] as! String
                            theBox.boxAddressSuite = test[1]  as! String
                            theBox.boxAddressCSZ = test[2] as! String
                            theBox.boxAddressCountry = test[3] as! String
                        }
                        
                        
                        print(test)
                    }
                    
                    theBox.boxLat = item.placemark.coordinate.latitude
                    
                    theBox.boxLong = item.placemark.coordinate.longitude
                    
                    
                    self.Boxes.append(theBox)
                    
                    
                    print()
                    print(item.placemark.coordinate.latitude)
                    print(item.placemark.coordinate.longitude)
                    
                    print()
                    print()
                    
                    
                }
                
                
            } else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                return
            }
            
        }
    }
    
    // MARK : Annotations
    
    func addPin(pinLat : Double, pinLong : Double, title : String) {
        
        let location = CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        
        self.mapView.addAnnotation(annotation)
    }

    
    // MARK : Delegate methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //self.locationManager.startUpdatingLocation()
        self.findUserLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.first
            print(location?.coordinate.latitude)
            print(location?.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            if let center = location?.coordinate {
                let region = MKCoordinateRegion(center: center, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.showsUserLocation = true
            }
        }
        
        self.locationManager.startUpdatingLocation()
        
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }

}

