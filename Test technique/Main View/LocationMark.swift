//
//  LocationMark.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import MapKit

class LocationMark: NSObject, MKAnnotation {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var title: String?
    private(set) var subtitle: String?
    private(set) var identifier: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, ID: Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        identifier = ID
    }
    
}
