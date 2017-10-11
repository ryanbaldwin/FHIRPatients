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
        model.save()
        dismiss(animated: true)
    }
    
    /// MARK: Gender Control
    
    @IBAction func genderValueChanged(_ sender: UISegmentedControl) {
        model.gender = PatientModel.Gender(rawValue: sender.selectedSegmentIndex)
    }
    
    /// MARK: DatePicker
    private func updateBirthdateTextField(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        birthdateTextField.text = formatter.string(from: date)
    }
    
    @IBAction func datePickerEditingDidBeging(_ sender: UIDatePicker) {
        updateBirthdateTextField(sender.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateBirthdateTextField(sender.date)
    }
    
    @IBAction func dateDoneTapped(_ sender: UIBarButtonItem) {
        updateBirthdateTextField(datePicker.date)
        model.dateOfBirth = datePicker.date
        birthdateTextField.resignFirstResponder()
    }
    
    @IBAction func dateCancelTapped(_ sender: UIBarButtonItem) {
        birthdateTextField.resignFirstResponder()
    }
    
    /// MARK: Textfields
    
    @IBAction func givenNameEditingChanged(_ sender: UITextField) {
        model.givenName = sender.text
    }
    
    @IBAction func familyNameEditingChanged(_ sender: UnderlinedTextField) {
        model.familyName = sender.text
    }
}

extension EditPatientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
