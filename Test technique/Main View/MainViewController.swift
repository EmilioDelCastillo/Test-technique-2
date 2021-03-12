//
//  ViewController.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import UIKit
import MapKit

protocol MainViewDelegate: class {
    func loadDataToMapView()
}

class MainViewController: UIViewController, MainViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countrySearchBar: UITextField!
    internal var currentCountryCode: String?
    
    private var currentRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        countrySearchBar.delegate = self
        countrySearchBar.text = "France"
        
        // Initial setup
        let france = CLLocationCoordinate2D(latitude: 46.2276,longitude: 2.2137)
        currentRegion = MKCoordinateRegion(center: france,
                                      latitudinalMeters: 1_000_000,
                                      longitudinalMeters: 1_000_000)
        
        mapView.setRegion(currentRegion!, animated: true)
        
        loadCountries()
        
        
    }
    
    // MARK: - Load data
    
    private func loadCountries() {
        AppData.shared.loadCountries { (error) in
            if error == nil {
                self.currentCountryCode = AppData.shared.getCountryCode(countryName: "France")
                self.loadDataToMapView()
                
            } else {
                
                // Notify the user
                let alert = UIAlertController(title: "Unable to load the countries",
                                              message: "We were unable to load the countries.",
                                              preferredStyle: .alert)
                
                // Not very sure about this...
                alert.addAction(UIAlertAction(title: "Try again",
                                              style: .default,
                                              handler: { (alert) in
                                                self.loadCountries()
                                              }))
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }

    /**
        Puts the markers on the map view, if a country code is set
     */
    internal func loadDataToMapView() {
        
        if let countryCode = currentCountryCode {
            
            mapView.removeAnnotations(mapView.annotations)
            
            AppData.shared.getData(for: countryCode) { error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.createMarkers()
                    
                    // The only way to make the annotations appear
                    DispatchQueue.main.async {
                        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                    }
                }
            }
            
        } else {
            // Notify the user
            let alert = UIAlertController(title: "Country not found",
                                          message: nil,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    internal func createMarkers() {

        //FIXME: This needs to be thought in order to avoid duplicates 🤔
        for loc in AppData.shared.locations {
            if let lat = loc.coordinates?.latitude, let lon = loc.coordinates?.longitude {
                
                let annotationLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = LocationMark(coordinate: annotationLocation,
                                              title: loc.city.safelyUnwrappedValue,
                                              subtitle: loc.location,
                                              ID: loc.locationId!)
                
                mapView.addAnnotation(annotation)
                
            }
        }
    }
}


