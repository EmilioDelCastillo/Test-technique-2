//
//  FilterViewController.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var mobileSwitch: UISwitch!
    @IBOutlet weak var analysisSwitch: UISwitch!
    
    @IBOutlet weak var sensorTypePicker: UIPickerView!
    @IBOutlet weak var entityPicker: UIPickerView!
    
    
    weak var delegate: MainViewDelegate?
    
    override func viewDidLoad() {
        
        entityPicker.delegate = self
        entityPicker.dataSource = self
        
        sensorTypePicker.delegate = self
        sensorTypePicker.dataSource = self
        
        mobileSwitch.setOn(AppData.shared.isMobile, animated: true)
        analysisSwitch.setOn(AppData.shared.isAnalysis, animated: true)
        
        
        var row = SensorType.allCases.firstIndex { (element) -> Bool in
            element.rawValue == AppData.shared.sensorType.rawValue
        }
        sensorTypePicker.selectRow(row ?? 0, inComponent: 0, animated: true)
        
        
        row = Entity.allCases.firstIndex { (element) -> Bool in
            element.rawValue == AppData.shared.entity.rawValue
        }
        entityPicker.selectRow(row ?? 0, inComponent: 0, animated: true)
        
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        AppData.shared.isMobile = mobileSwitch.isOn
        AppData.shared.isAnalysis = analysisSwitch.isOn
        AppData.shared.sensorType = SensorType.allCases[sensorTypePicker.selectedRow(inComponent: 0)]
        AppData.shared.entity = Entity.allCases[entityPicker.selectedRow(inComponent: 0)]
        
        delegate?.reload()
        dismiss(animated: true, completion: nil)
    }
    
}
