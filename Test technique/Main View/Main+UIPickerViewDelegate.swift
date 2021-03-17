//
//  Main+UIPickerViewDelegate.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 14/03/2021.
//

import UIKit

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
        
        // The timer prevents the app from loading useless countries while the user is scrolling trough the list.
        func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                if countryCode != self.currentCountryCode {
                    self.currentCountryCode = countryCode
                }
            }
        }
        
        let countryName = AppData.shared.countries[row].name!
        
        // Do not reload if it's the same country
        let countryCode = AppData.shared.getCountryCode(countryName: countryName)
        
        timer?.invalidate()
        startTimer()
        
    }
}
