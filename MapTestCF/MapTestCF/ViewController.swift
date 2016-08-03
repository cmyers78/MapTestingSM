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
    
    var collected : Int = 0
    
    var locationManager = CLLocationManager()
    
    var Boxes = [Box]()
    
    let controller = APIController()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.fetchGoogleBox()
        controller.findMKBox(40.233844, long: -111.658534)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        //self.locationManager.startUpdatingLocation()
        self.findUserLocation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dropPin), name: kNOTIFY, object: nil)
        
        // add obvserver and call function
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK : Find user location & boxes
    
    func findUserLocation() {
        
        let status = CLAuthorizationStatus.AuthorizedAlways
        
        if status != .Denied {
            self.mapView.showsUserLocation = true
            self.locationManager.requestLocation()
        }
    }
    

    
    func dropPin() {
        print("drop pin called")
        for box in DataStorage.sharedInstance.boxesArray {
            
            self.addPin(box.boxLat, pinLong: box.boxLong, title: box.boxName, address: box.boxAddressStreet + " " + box.boxAddressCSZ)
            
        
        }
    }
    
    // MARK : Annotations
    
    func addPin(pinLat : Double, pinLong : Double, title : String, address : String) {
        
        let location = CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong)
        let annotation = CustomBoxMKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = address

        
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
            let span = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
            if let center = location?.coordinate {
                let region = MKCoordinateRegion(center: center, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.showsUserLocation = true
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation.isKindOfClass(CustomBoxMKPointAnnotation) {
            let identifier = "kettleBell"
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            
            annotationView.canShowCallout = true
            
            let imageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
            imageView.contentMode = .ScaleAspectFit
            
            imageView.image = UIImage(named: "kettlebellx24")
            
            annotationView.image = imageView.image
            
            return annotationView
            
        }
        return nil
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }

}

