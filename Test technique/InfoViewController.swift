//
//  DetailsViewController.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import UIKit

class InfoViewController: UIViewController {

    var city: String?
    @IBOutlet weak var cityLabel: UILabel!
    
    var location: String?
    @IBOutlet weak var locationLabel: UILabel!
    
    var parameter: String?
    @IBOutlet weak var parameterLabel: UILabel!
    
    var value: Double?
    @IBOutlet weak var valueLabel: UILabel!
    
    var isMobile: Bool?
    @IBOutlet weak var mobileLabel: UILabel!
    
    var isAnalysis: Bool?
    @IBOutlet weak var analysisLabel: UILabel!
    
    var entity: String?
    @IBOutlet weak var entityLabel: UILabel!
    
    var sensorType: String?
    @IBOutlet weak var sensorTypeLabel: UILabel!
    
    var unit: String?
    @IBOutlet weak var unitLabel: UILabel!
    
    let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.maximumFractionDigits = 4

        let formattedValue = numberFormatter.string(from: NSNumber(value: value!))
        
        cityLabel.text       = city.safelyUnwrappedValue
        locationLabel.text   = location.safelyUnwrappedValue
        parameterLabel.text  = parameter.safelyUnwrappedValue
        entityLabel.text     = entity.safelyUnwrappedValue
        sensorTypeLabel.text = sensorType.safelyUnwrappedValue
        unitLabel.text       = unit.safelyUnwrappedValue
        valueLabel.text      = formattedValue.safelyUnwrappedValue

        if let mobile = isMobile {
            mobileLabel.text = (mobile) ? "Location: Mobile" : "Location: Fixed"
        } else {
            mobileLabel.text = "unknown"
        }
        
        if let analysis = isAnalysis {
            analysisLabel.text = (analysis) ? "Data: Product of analysis/aggregation" : "Data: Raw"
        } else {
            analysisLabel.text = "unknown"
        }
        
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if let VC = self.presentingViewController as? MainViewController {
            
            // There may not be one!
            if let annotation = VC.mapView.selectedAnnotations.first {
                VC.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
    }
}
