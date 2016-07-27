//
//  Box.swift
//  MapTestCF
//
//  Created by Christopher Myers on 7/27/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class Box: NSObject {

    var boxName : String = ""
    var boxPhone : String = ""
    //var boxURL : NSURL
    var boxAddressStreet : String = ""
    var boxAddressSuite : String = ""
    var boxAddressCSZ : String = ""
    var boxAddressCountry : String = ""
    var boxLat : Double = 0.0
    var boxLong : Double = 0.0
    
    override init() {
        super.init()
        
        self.boxName = ""
        self.boxPhone = ""
        //self.boxURL =
        self.boxAddressStreet = ""
        self.boxAddressSuite = ""
        self.boxAddressCSZ = ""
        self.boxAddressCountry = ""
        self.boxLat = 0.0
        self.boxLong = 0.0
        
    
    }
}