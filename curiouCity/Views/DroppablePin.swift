//
//  DroppablePin.swift
//  curiouCity
//
//  Created by Mostafa Alaa on 8/12/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject,MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier : String
    init(coordinate:CLLocationCoordinate2D,identifier:String) {
        self.coordinate=coordinate
        self.identifier=identifier
        super.init()
    }
    
    
    
    
}
