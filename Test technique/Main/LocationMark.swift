//
//  LocationMark.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import UIKit
import MapKit

class LocationMark: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, ID: Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        identifier = ID
    }
    
}
