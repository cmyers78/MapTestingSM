//
//  DataStorage.swift
//  MapTestCF
//
//  Created by Christopher Myers on 7/28/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

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
    
        // loop through the array and compare the box at index with the google box name
        // if equality is true, skip
        // if equality is not true, add the box to the array
    
}
