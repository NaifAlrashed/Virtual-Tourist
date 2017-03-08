//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/7/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
