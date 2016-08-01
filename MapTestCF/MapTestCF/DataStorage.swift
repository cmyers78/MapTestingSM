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
    
    var collected : Int = 0
    
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
    
    func boxesAtIndex(index : Int) -> Box? {
        if self.boxesArray.count >= 0 && index < self.boxesArray.count {
            return self.boxesArray[index]
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(countUp), name: "CountUp", object: nil)
        
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
                        
                        print(theBox.boxName)
                        
                        if let phone = item.phoneNumber {
                            theBox.boxPhone = phone
                        }
                        
                        if let webAddress = item.url {
                            theBox.boxURL = webAddress
                        }
                        
                        var foundAddress = true
                        
                        if let test = item.placemark.addressDictionary?["FormattedAddressLines"] as? NSArray{
                            
                            if test.count < 3 {
                                foundAddress = false
                            }
                            else if test.count == 3 {
                                
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
                        
                        if foundAddress == true {
                            self.boxesArray.append(theBox)
                            theBox.logItems()
                            print()
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("countUp", object: nil)
                            // add notification here - post notification here
                            //print("The box added is: \(theBox.boxName)")
                        }
                        
                        
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
    
    func countUp() {
        print("count up called")
        collected = collected + 1
        print("collected count == \(collected)")
        
        // Check the count of collected data and compare it with the count of your google Array.
        
        if collected == self.googleArray.count {
            print("we are finished! Maybe send final Notiication?")
        }
        
        
    }

    // loop through the array and compare the box at index with the google box name
    // if equality is true, skip
    // if equality is not true, add the box to the array
    
}
