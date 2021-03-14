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
    @IBOutlet weak var parameterPicker: UIPickerView!
    
    
    weak var delegate: MainViewDelegate?
    
    override func viewDidLoad() {
        
        entityPicker.delegate = self
        entityPicker.dataSource = self
        
        sensorTypePicker.delegate = self
        sensorTypePicker.dataSource = self
        
        parameterPicker.delegate = self
        parameterPicker.dataSource = self
        
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
        
        loadParameters() {
            DispatchQueue.main.async {
                self.parameterPicker.reloadAllComponents()
                row = AppData.shared.parameters.firstIndex(where: { (element) -> Bool in
                    element.name == AppData.shared.parameter
                })
                self.parameterPicker.selectRow(row ?? 0, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        AppData.shared.isMobile = mobileSwitch.isOn
        AppData.shared.isAnalysis = analysisSwitch.isOn
        AppData.shared.sensorType = SensorType.allCases[sensorTypePicker.selectedRow(inComponent: 0)]
        AppData.shared.entity = Entity.allCases[entityPicker.selectedRow(inComponent: 0)]
        
        let row = parameterPicker.selectedRow(inComponent: 0)
        AppData.shared.parameter = AppData.shared.parameters[row].name!
        
        delegate?.loadDataToMapView()
        dismiss(animated: true, completion: nil)
    }
    
    private func loadParameters(completion: (() -> Void)? = nil ) {
        
        // It's not necessary to load the parameters every time
        if AppData.shared.parameters == nil {
            AppData.shared.loadParameters { (error) in
                if error == nil {
                    
                    completion?()
                    
                } else {
                    
                    // Notify the user
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Unable to load the parameters",
                                                      message: nil,
                                                      preferredStyle: .alert)
                        
                        // Not very sure about this...
                        alert.addAction(UIAlertAction(title: "Try again",
                                                      style: .default,
                                                      handler: { (alert) in
                                                        self.loadParameters()
                                                      }))
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                    
                }
            }
            
        } else {
            completion?()
        }
        
    }
}
