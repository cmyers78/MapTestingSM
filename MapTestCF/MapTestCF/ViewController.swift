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
    
    var selectedPin : MKPlacemark? = nil
    var mapName : String = ""
    
    var locationManager = CLLocationManager()
    
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
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
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
            
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            if let annotationView = annotationView {
                
                annotationView.canShowCallout = true
                
                let imageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
                imageView.contentMode = .ScaleAspectFit
                
                imageView.image = UIImage(named: "kettlebellx24")
                
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "carX32"), forState: .Normal)
                button.addTarget(self, action: #selector(self.getDirections), forControlEvents: .TouchUpInside)
                annotationView.leftCalloutAccessoryView = button
                
                annotationView.image = imageView.image
                
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        //print("POPUP ANNOTATE")
        // I need to set selectedPin equal to the pin's coordinates
        if let coordinate = view.annotation?.coordinate {
            
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            self.selectedPin = placemark
            
            if let mName = view.annotation?.title {
                self.mapName = mName!
            }
        }
        
    }
    
    func getDirections() {
        print("button tapped")
        
        
        let mapItem = MKMapItem(placemark: self.selectedPin!)
        mapItem.name = self.mapName
        if let lat = self.selectedPin?.coordinate.latitude, long = self.selectedPin?.coordinate.longitude {
            
            let regionDistance : CLLocationDistance = 7500
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let regionSpan = MKCoordinateRegionMakeWithDistance(coord, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving ]
            
            mapItem.openInMapsWithLaunchOptions(options)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
}

