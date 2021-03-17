//
//  Main+Navigation.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import UIKit

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showInfo":
            if let destination = segue.destination as? InfoViewController {
                
                // Get the location corresponding to the mark identifier
                if let location = AppData.shared.locations.first(where: { (loc) -> Bool in
                    loc.locationId == (sender as! LocationMark).identifier
                }) {
                    destination.city = location.city
                    destination.location = location.location
                    
                    // Get the corresponding parameter display name from the list of parameters
                    let parameterDisplayName = AppData.shared.parameters?.first { (param) -> Bool in
                        param.name == AppData.shared.parameter
                    }
                    destination.parameter = parameterDisplayName?.displayName
                    
                    destination.value = location.value
                    destination.unit = location.unit
                    destination.isMobile = location.isMobile
                    destination.isAnalysis = location.isAnalysis
                    destination.entity = location.entity
                    destination.sensorType = location.sensorType
                }
            }
        case "showFilters":
            if let destination = segue.destination as? FilterViewController {
                destination.delegate = self
            }
        default:
            print("Unknown segue")
        }
    }
}
