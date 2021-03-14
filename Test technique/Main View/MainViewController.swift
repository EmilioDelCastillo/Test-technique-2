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

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppData.shared.countries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppData.shared.countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countryName = AppData.shared.countries[row].name!
        currentCountryCode = AppData.shared.getCountryCode(countryName: countryName)
    }
    
}

class MainViewController: UIViewController, MainViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    internal var currentCountryCode: String? {
        didSet {
            loadDataToMapView()
        }
    }
    
    private var currentRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
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
//                self.loadDataToMapView()
                
                DispatchQueue.main.async {
                    self.countryPicker.reloadAllComponents()
                    let row = AppData.shared.countries?.firstIndex { (country) -> Bool in
                        country.name == "France"
                    }
                    self.countryPicker.selectRow(row ?? 0, inComponent: 0, animated: true)
                }
                
            } else {
                
                // Notify the user
                DispatchQueue.main.async {
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
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }

    /**
        Puts the markers on the map view, if a country code is set
     */
    internal func loadDataToMapView() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        
        if let countryCode = currentCountryCode {
            
            mapView.removeAnnotations(mapView.annotations)
            
            AppData.shared.getData(for: countryCode) { error in
                if error != nil {
                    var errorMessage: String!
                    
                    
                    if let test = error as? ResultError {
                        
                        switch test {
                        case .negativeCount:
                            errorMessage = "Negative amount found."
                        case .noResult:
                            errorMessage = "No results."
                        case .unknownError:
                            errorMessage = "Unknown error."
                        }
                        
                    } else {
                        errorMessage = error?.localizedDescription
                    }
                    
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                        alert.message = errorMessage
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    self.createMarkers {
                        // The only way to make the annotations appear
                        DispatchQueue.main.async {
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                            self.spinner.stopAnimating()
                        }
                    }
                    
                }
            }
            
        } else {
            
            // Notify the user
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Country not found",
                                              message: nil,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    internal func createMarkers(completion: @escaping () -> Void) {

        //FIXME: This needs to be thought in order to avoid duplicates 🤔
        
        // This operation can be expensive
        DispatchQueue.global(qos: .userInteractive).async {
            for loc in AppData.shared.locations {
                if let lat = loc.coordinates?.latitude, let lon = loc.coordinates?.longitude {
                    
                    let annotationLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let annotation = LocationMark(coordinate: annotationLocation,
                                                  title: loc.city.safelyUnwrappedValue,
                                                  subtitle: loc.location,
                                                  ID: loc.locationId!)
                    
                    self.mapView.addAnnotation(annotation)
                    
                }
            }
            completion()
        }
    }
}


