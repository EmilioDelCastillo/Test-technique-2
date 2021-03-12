//
//  Filter+UIPickerView.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import UIKit

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        
        case 0: // Sensor Type picker
            return SensorType.allCases.count
        
        case 1: // Entity picker
            return Entity.allCases.count
            
        default:
            assert(false, "Unknown tag \(pickerView.tag)")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        
        case 0: // Sensor Type picker
            return SensorType.allCases[row].rawValue
            
        case 1: // Entity picker
            return Entity.allCases[row].rawValue
            
        default:
            assert(false, "Unknown tag \(pickerView.tag)")
            return "?"
        }
    }
    
}
