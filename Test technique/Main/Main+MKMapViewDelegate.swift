//
//  Main+MKMapViewDelegate.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import MapKit

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "test") {
            
            return annotationView

        } else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "test")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            return annotationView
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        performSegue(withIdentifier: "showInfo", sender: view.annotation)
    
    }
}
