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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.text       = city.safelyUnwrappedValue
        locationLabel.text   = location.safelyUnwrappedValue
        parameterLabel.text  = parameter.safelyUnwrappedValue
        entityLabel.text     = entity.safelyUnwrappedValue
        sensorTypeLabel.text = sensorType.safelyUnwrappedValue
        unitLabel.text       = unit.safelyUnwrappedValue
        valueLabel.text      = value?.description

        if let mobile = isMobile {
            mobileLabel.text = (mobile) ? "Mobile" : "Not mobile"
        } else {
            mobileLabel.text = "unknown"
        }
        
        if let analysis = isAnalysis {
            analysisLabel.text = (analysis) ? "Analysis" : "Not analysis"
        } else {
            analysisLabel.text = "unknown"
        }
        
    }
}
