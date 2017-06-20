//
//  SettingsViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 20/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    
    let currencyArray = ["$", "R"]
    
    let currencyStringArray = ["USD, $", "RUB, R"]
    
    var currencyPickerView: UIPickerView!
    var currencyString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signOutButton.layer.cornerRadius = 8
        self.signOutButton.layer.borderWidth = 1
        self.signOutButton.layer.borderColor = UIColor.blue.cgColor
        
        currencyPickerView = UIPickerView()
        currencyPickerView.delegate = self
        currencyTextField.inputView = currencyPickerView
        currencyTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func saveSettings() {
        userDefaults.setValue(currencyTextField.text!, forKey: kCURRENCY)
        userDefaults.synchronize()
    }
    
    func updateUI() {
        
        currencyTextField.text = userDefaults.object(forKey: kCURRENCY) as! String
        currencyString = currencyTextField.text!
        
    }

    
    @IBAction func actionSignOutButtonTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func actionDismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}

// MARK: - UIPickerViewDelegate & UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPickerView {
            return currencyStringArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPickerView {
            
            return currencyStringArray[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == currencyPickerView {
            
            currencyTextField.text = currencyArray[row]
            
        }
        
        saveSettings()
        updateUI()
        
    }
}


// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == currencyTextField && currencyString == "" {
            currencyString = currencyArray[0]
            
        }
        currencyTextField.text = currencyString
        
    }
}

















