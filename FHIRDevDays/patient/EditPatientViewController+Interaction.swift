//
//  EditPatientViewController+Interaction.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension EditPatientViewController {
    /// MARK: Controller navigationItem buttons
    @objc func cancelEditButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func doneEditButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    /// MARK: Gender Control
    
    @IBAction func genderValueChanged(_ sender: UISegmentedControl) {
        model.gender = PatientModel.Gender(rawValue: sender.selectedSegmentIndex)
    }
    
    /// MARK: DatePicker
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        birthdateTextField.text = formatter.string(from: sender.date)
    }
    
    @IBAction func dateDoneTapped(_ sender: UIBarButtonItem) {
        birthdateTextField.resignFirstResponder()
    }
    
    @IBAction func dateCancelTapped(_ sender: UIBarButtonItem) {
        birthdateTextField.resignFirstResponder()
    }
}
