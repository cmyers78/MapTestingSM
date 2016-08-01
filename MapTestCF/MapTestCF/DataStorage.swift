//
//  DataStorage.swift
//  MapTestCF
//
//  Created by Christopher Myers on 7/28/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DataStorage: NSObject {
    
    static let sharedInstance = DataStorage()
    private override init() {
        
    }
    
    private var boxesArray = [Box]()
    
    private var googleArray = [Box]()
    
    func addMKBox(box : Box) {
        self.boxesArray.append(box)
        print(box.boxName + " MK")
    }
    
    func removeBoxes() {
        self.boxesArray.removeAll()
    }
    
    func numberOfBoxes() -> Int {
        return self.boxesArray.count
    }
    
    func googleBoxAtIndex(index : Int) -> Box? {
        if self.googleArray.count >= 0 && index < self.googleArray.count {
            return self.googleArray[index]
        }
        return nil
    }

    
    func addGoogleBox(box : Box) {
        
        var isFound = false
        
        for boxes in boxesArray {
            
            //print("\(box.boxName.lowercaseString) != \(boxes.boxName.lowercaseString)")
            if box.boxName.lowercaseString == boxes.boxName.lowercaseString {
                isFound = true
            }
        }
        
        if isFound == false {
            self.googleArray.append(box)
        }
        
        print("count == \(self.googleArray.count)")
        
        for name in googleArray {
            print("Google Array: \(name.boxName)")
        }
        
        for nameMK in boxesArray {
            print("MK Array: \(nameMK.boxName)")
        }
    }
    
    func parseGoogleBoxes() {
        
        for box in googleArray {
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = box.boxName
            
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler{
                (response, error) in
                
                if let response = response {
                    
                    if response.mapItems.count > 0 {
                        
                        let item = response.mapItems[0]
                        
                        let theBox = Box()
                        
                        if let name = item.name {
                            theBox.boxName = name
                        }
                        
                        if let phone = item.phoneNumber {
                            theBox.boxPhone = phone
                        }
                        
                        if let webAddress = item.url {
                            theBox.boxURL = webAddress
                        }
                        
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
                        }
                        
                        theBox.boxLat = item.placemark.coordinate.latitude
                        
                        theBox.boxLong = item.placemark.coordinate.longitude
                        
                        
                        self.boxesArray.append(theBox)
                        print("The box added is: \(theBox.boxName)")
                        
                        //self.googleArray.removeAtIndex(DataStorage.sharedInstance.googleBoxAtIndex(theBox))
                        // remove from google array
                        
                    } else {
                        print("Search results not found for: \(box.boxName)")
                        // remove from google array
                    }
                    
                } else {
                    print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                    return
                }
                
            }
        }
        
        
    }
    
    // loop through the array and compare the box at index with the google box name
    // if equality is true, skip
    // if equality is not true, add the box to the array
    
}
