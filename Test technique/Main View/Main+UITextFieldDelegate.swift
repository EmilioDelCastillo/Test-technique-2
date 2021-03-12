//
//  Main+UITextFieldDelegate.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        currentCountryCode = AppData.shared.getCountryCode(countryName: textField.text!)
        
        loadDataToMapView()
        
        textField.resignFirstResponder()
        
        return false
        
    }
    
}
