//
//  FilterViewController.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var mobileSwitch: UISwitch!
    @IBOutlet weak var analysisSwitch: UISwitch!
    
    @IBOutlet weak var sensorTypePicker: UIPickerView!
    @IBOutlet weak var entityPicker: UIPickerView!
    @IBOutlet weak var parameterPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let radius: CGFloat = 4
    weak var delegate: MainViewDelegate?
    
    override func viewDidLoad() {
        isModalInPresentation = true
        
        entityPicker.delegate = self
        entityPicker.dataSource = self
        
        sensorTypePicker.delegate = self
        sensorTypePicker.dataSource = self
        
        parameterPicker.delegate = self
        parameterPicker.dataSource = self
        
        datePicker.maximumDate = Foundation.Date()
        datePicker.date = AppData.shared.dateToday
        
        mobileSwitch.setOn(AppData.shared.isMobile, animated: true)
        analysisSwitch.setOn(AppData.shared.isAnalysis, animated: true)
        
        loadButton.layer.cornerRadius = radius
        cancelButton.layer.cornerRadius = radius
        
        // The three following "blocks" make sure that the picker views are set
        // with the last selected values.
        var row = SensorType.allCases.firstIndex { (element) -> Bool in
            element.rawValue == AppData.shared.sensorType.rawValue
        }
        sensorTypePicker.selectRow(row ?? 0, inComponent: 0, animated: true)
        
        
        row = Entity.allCases.firstIndex { (element) -> Bool in
            element.rawValue == AppData.shared.entity.rawValue
        }
        entityPicker.selectRow(row ?? 0, inComponent: 0, animated: true)
        
        
        row = AppData.shared.parameters.firstIndex(where: { (element) -> Bool in
            element.name == AppData.shared.parameter
        })
        parameterPicker.selectRow(row ?? 0, inComponent: 0, animated: true)

    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        AppData.shared.isMobile = mobileSwitch.isOn
        AppData.shared.isAnalysis = analysisSwitch.isOn
        AppData.shared.sensorType = SensorType.allCases[sensorTypePicker.selectedRow(inComponent: 0)]
        AppData.shared.entity = Entity.allCases[entityPicker.selectedRow(inComponent: 0)]
        
        let row = parameterPicker.selectedRow(inComponent: 0)
        AppData.shared.parameter = AppData.shared.parameters[row].name!
        
        AppData.shared.dateToday = datePicker.date
        
        delegate?.loadDataToMapView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
